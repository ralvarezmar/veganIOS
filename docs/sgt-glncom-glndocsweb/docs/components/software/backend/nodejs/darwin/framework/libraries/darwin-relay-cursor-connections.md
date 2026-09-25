# Darwin Relay Cursor Connections

## Summary

Relay cursor connections add support to cursor pagination to a Darwin GraphQL related project. The purpose is to provide some interfaces and abstract classes to reduce effort to add pagination to your GraphQL endpoint.

## Module structure

This generated module contains the following structure:

```yaml
.
├── .editorconfig      # EditorConfig style defined
├── .eslintrc.js       # Configuration for linter
├── .git/              # Git control version folder
├── .gitignore         # Files to ignore in git
├── .npmrc             # NPM configuration file
├── src/               # Source code of application
│   ├── relay/         # Folder with cursor relay implementation
│   └── validators/    # Validator helpers
├── node_modules/
├── package-lock.json  # Automatically generated for any operations where npm
│                      # modifies either the node_modules tree, or package.json
├── package.json       # Application dependencies and configuration
└── test               # Application tests
```

## How to use it

We need to implement a database connector to paginate our data and entities to paginate.

### Database connector

#### Connection factory

This is an async function where will called from our resolver to fetch cursor relay needed data:

- total items count.
- Search before offset.
- Search after offset.
- Set skip items.
- Set items to take from db.
- Populate page info: startCursor, endCursor, hasPreviousPage, hasNextPage.

We show you a TypeORM implementation sample:

```js
import {
  ConnectionArguments,
  getOffsetWithDefault,
  offsetToCursor
} from 'graphql-relay';
import { Repository } from 'typeorm';

import { Connection } from '@darwin-node/relay-cursor-connections';

export async function connectionFromRepository<T> (
  args: ConnectionArguments,
  repository: Repository<T>
): Promise<Connection<T>> {
  const { before, after, first, last } = args;

  const totalCount = await repository.count();

  // offsets
  const beforeOffset = getOffsetWithDefault(before, totalCount);
  const afterOffset = getOffsetWithDefault(after, -1);

  let startOffset = Math.max(-1, afterOffset) + 1;
  let endOffset = Math.min(beforeOffset, totalCount);

  if (first) {
    endOffset = Math.min(endOffset, startOffset + first);
  }

  if (last) {
    startOffset = Math.max(startOffset, endOffset - last);
  }

  // skip, take
  const skip = Math.max(startOffset, 0); // sql offset
  const take = Math.max(endOffset - startOffset, 1); // sql limit

  // get items
  const entities = await repository.find({ skip, take });

  const edges = entities.map((entity, index) => ({
    cursor: offsetToCursor(startOffset + index),
    node: entity
  }));

  // page info
  const { length, 0: firstEdge, [length - 1]: lastEdge } = edges;
  const lowerBound = after ? afterOffset + 1 : 0;
  const upperBound = before ? Math.min(beforeOffset, totalCount) : totalCount;

  const pageInfo = {
    startCursor: firstEdge ? firstEdge.cursor : null,
    endCursor: lastEdge ? lastEdge.cursor : null,
    hasPreviousPage: last ? startOffset > lowerBound : false,
    hasNextPage: first ? endOffset < upperBound : false
  };

  return {
    edges,
    pageInfo,
    totalCount
  };
}
```

#### Context interface

It is an interface to declare database and repositories used. It is ORM implementation dependent. An implementation example:

```js
import { Connection, Repository } from 'typeorm';

import { Node } from '@darwin-node/relay-cursor-connections';

export interface Context {
  database: Connection
  repositories: Record<string, Repository<Node>>
}
```

#### Node resolver

This is a TypeGraphQL resolver to globalId field implementation and node and nodes query by globalId.

```js
import { UserInputError } from 'apollo-server-express';
import { fromGlobalId, toGlobalId } from 'graphql-relay';
import {
  Arg,
  Ctx,
  FieldResolver,
  ID,
  Info,
  Query,
  Resolver,
  Root
} from 'type-graphql';
import { Service } from 'typedi';
import { Node } from '@darwin-node/relay-cursor-connections';
import { Context } from './context.interface';

@Resolver(() => Node)
@Service()
export class NodeResolver {
  @FieldResolver()
  globalId (
    @Root() { id }: { id: string },
    @Info() { parentType: { name } }: { parentType: { name: string } }
  ): string {
    return toGlobalId(name, id);
  }

  private async fetcher (
    globalId: string,
    { repositories }: Context
  ): Promise<Node | undefined> {
    const { type, id } = fromGlobalId(globalId);

    // eslint-disable-next-line security/detect-object-injection
    const repository = repositories[type];

    if (!repository) {
      throw new UserInputError(
        `Could not resolve to a node with the global ID of '${globalId}'`
      );
    }

    return await repository.findOne(id);
  }

  @Query(() => Node, {
    nullable: true,
    description: 'Fetches an object given its global ID.'
  })
  node (
    @Arg('id', () => ID, { description: 'The global ID of the object.' })
      globalId: string,
    @Ctx() context: Context
  ): ReturnType<NodeResolver['fetcher']> {
    return this.fetcher(globalId, context);
  }

  @Query(() => [Node], {
    nullable: 'items',
    description: 'Fetches objects given their global IDs.'
  })
  nodes (
    @Arg('ids', () => [ID], { description: 'The global IDs of the objects.' })
      globalIds: Array<string>,
    @Ctx() context: Context
  ): Array<ReturnType<NodeResolver['fetcher']>> {
    return globalIds.map(id => this.fetcher(id, context));
  }
}
```

### Entities to paginate

#### EdgeType

The EdgeType allows you to create a GraphQL relay edge ObjectType from a base type. ObjectTypes are what you can return from any graphql resolver, see the examples for more full implementations of how to connect to resolvers.

```js
import { ObjectType } from 'type-graphql';

import { EdgeType } from '@darwin-node/relay-cursor-connections';
import { CommentType } from './comment.type';

@ObjectType()
export class CommentEdge extends EdgeType(CommentType) {}
```

#### ConnectionType

This class will be used by TypeGraphQL in our resolver to know data returned. This class is a gateway between our ObjectType entity and relay connection field tree. An example:

```js
import { ObjectType } from 'type-graphql';

import { ConnectionType } from '@darwin-node/relay-cursor-connections';
import { CommentEdge } from './comment.edge';

@ObjectType()
export class CommentConnection extends ConnectionType(CommentEdge) {}
```

Next step is to implement in our resolver the pagination resolver:

```js
@Resolver()
@Service()
export class CommentsResolver extends CommentsService {
  @InjectRepository(CommentEntity)
  private readonly repository!: Repository<CommentEntity>

  @Query(() => CommentConnection)
  async findAllComments (@Args() args: ConnectionArguments): Promise<Connection<CommentEntity>> {
    return await connectionFromRepository(args, this.repository);
  }
```

It is all you need to do to create a ObjectType class, EdgeType class, and then plug them in to the ConnectionType class.

## Unit Testing

For testing purposes [Jest](https://jestjs.io/) is used.

Try yourself

```sh
npm run test:coverage
```

## How to run the artifact

Before run start command run

```sh
npm run tsc
```

Run command

```sh
npm run start
```

## How to develop the artifact

Run command

```sh
npm run dev
```
