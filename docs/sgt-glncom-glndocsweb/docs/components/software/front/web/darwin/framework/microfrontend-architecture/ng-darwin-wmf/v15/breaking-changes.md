# Breaking Changes

From Angular v14 the `inject()` function can be used in components, directives and pipes.
So it is no longer mandatory to pass dependencies as parameters to the `super()` method from the constructor of classes that extend `MicrofrontContainerDirective` and `MicrofrontDirective` directives.

- Extending **MicrofrontContainerDirective**

    ``` ts
    // Before
    export class ExampleContainerComponent extends MicrofrontContainerDirective {
      constructor(
        private _router: Router,
        private _activatedRoute: ActivatedRoute,
      ) {
        super(_router, _activatedRoute);
      }
    }
    ```

    ``` ts
    // After
    export class ExampleContainerComponent extends MicrofrontContainerDirective {
    }
    ```

- Extending **MicrofrontDirective**

    ``` ts
    // Before
    export class ExampleComponent extends MicrofrontDirective {
      constructor(
        private readonly _mountPathService: MountPathService,
        private readonly _securityLiteService: SecurityLiteService,
        private readonly _router: Router,
        private readonly _changeDetectorRef: ChangeDetectorRef,
        private readonly _ngZone: NgZone,
    ) {
      super(
        _mountPathService,
        _securityLiteService,
        _router,
        _changeDetectorRef,
        _ngZone,
      );
    }

      override async ngOnInit(): Promise<void> {
        await super.ngOnInit();
        await this._securityLiteService.initialize();
      }
    }
    ```

    ``` ts
    // After (using the `inject` function)
    export class ExampleComponent extends MicrofrontDirective {
      private _securityLiteService = inject(SecurityLiteService);

      override async ngOnInit(): Promise<void> {
        await super.ngOnInit();
        await this._securityLiteService.initialize();
      }
    }
    ```

    ``` ts
    // After (using the constructor)
    export class ExampleComponent extends MicrofrontDirective {
      constructor( private readonly _securityLiteService: SecurityLiteService ) {
        super();
      }

      override async ngOnInit(): Promise<void> {
        await super.ngOnInit();
        await this._securityLiteService.initialize();
      }
    }
    ```
