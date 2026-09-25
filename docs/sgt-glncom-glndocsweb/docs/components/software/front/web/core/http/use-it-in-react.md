# Use it in React

## Capabilities

Allows passing HTTP requests from Microfrontends to the Shell app for being managed there and handling the responses back to the Microfrontends using Custom Events.

## Installation

```bash
npm i @santander/http-react
```

## Usage

### React Shell

In the src folder of your Shell application, find the file App.tsx, import the function startCustomEventsListener and call it inside a useEffect that executes only one time, like the example below:

```tsx
import { startCustomEventsListener } from '@santander/http-react';
const App: FC = (): JSX.Element => {

  useEffect(() => {
    startCustomEventsListener();
  }, []);

  return (
    // your JSX code
  )
}
export default App;
```

### React Micro Front-End

For making a request from the micro front-end, yo can do it like the example below:

```tsx
import { FetchManager, FetchResponse, FetchResponseError } from '@santander/http-react';

interface Post {
  id: number;
  title: string;
}

export function App() {
  const fetchManager = new FetchManager(); // also you can pass as parameter, an array of type FetchPlugin for handling request/response

  const getPosts = () => {
    fetchManager
      .requestFromMfe<Post[]>({
        url: 'https://example.com/posts',
        options: {
          method: 'GET',
        },
      })
      .then((response: FetchResponse<Post[]>) => {
        console.log(response);
      })
      .catch((error: FetchResponseError) => {
        console.error(JSON.stringify(error));
      });
  };

  return (
    // Your TSx code
  );
}
export default App;
```

### React SPA outside Shell/Micro-Microfrontend architecture

You can make an HTTP request with FetchManager using the following methods:

```typescript

async GET<T>(url: string, options?: Partial<RequestInit>): Promise<FetchResponse<T>>
async POST<T>(url: string, body?: Body, options?: Partial<RequestInit>): Promise<FetchResponse<T>>
async PUT<T>(url: string, body?: Body, options?: Partial<RequestInit>): Promise<FetchResponse<T>>
async DELETE<T>(url: string, options?: Partial<RequestInit>): Promise<FetchResponse<T>>
async PATCH<T>(url: string, body?: Body, options?: Partial<RequestInit>): Promise<FetchResponse<T>>

// This is an example of how to make a POST request

import { FetchManager } from '@santander/http-react';

const fetchManager = new FetchManager(); // also you can pass as parameter, an array of type FetchPlugin for handling request/response
fetchManager.POST('https://test.com', JSON.stringify({ key: 'value' }));
```
