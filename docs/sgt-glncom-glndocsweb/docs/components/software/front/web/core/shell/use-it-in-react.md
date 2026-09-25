# Use it in React

## Capabilities

### Add a SanMicrofront Component

This feature enables the shell to seamlessly integrate a WebComponent as a microfrontend through a template, making the loading process transparent to the developer.

## Installation

Install the Shell library:

```bash
npm install @santander/shell
```

## Capabilities

## Usage

### Darwin

```typescript
function DarwinMicrofront() {
  const sanMicrofrontRef = useRef();

  useEffect(() => {
    if (sanMicrofrontRef.current) {
      (sanMicrofrontRef.current as any).config = {
        type: LoadPluginType.Darwin,
        remoteEntry: [
          'http://localhost:4201/polyfills.js',
          'http://localhost:4201/styles.js',
          'http://localhost:4201/vendor.js',
          'http://localhost:4201/main.js'
        ],
        tag: 'mex-rost-demomfedw'
      };
    }
  }, []);
  return (
    <san-microfront ref={sanMicrofrontRef}></san-microfront>
  );
}
```

### React ODS

```typescript
function OdsMicrofront(props: any) {
  const [sessionData, setSessionData] = useState({} as any);

  useEffect(() => {
    console.log(sessionData, '- Has changed');
  }, [sessionData]);

  const sanMicrofrontRef = useRef();
  useEffect(() => {
    const microfront = sanMicrofrontRef.current as any;
    if (microfront && sessionData.accessToken) {
      microfront.config = {
        type: 'ODS',
        projectId: 'mb-ui',
        verticalId: 'cards',
        variant: 'us',
        initializers: {
          data: {
            sessionData: {
              accessToken: sessionData.accessToken,
              refreshToken: sessionData.refreshToken,
              expiresIn: sessionData.expiresIn,
              sessionExpiresAt: sessionData.sessionExpiresAt,
              username: sessionData.username,
            },
          },
        },
      };
    }
  }, [sessionData]);
  return (
    <div>
      <OdsLogin
        onSessionDataChange={(data: any) => {
          setSessionData(data);
        }}
      ></OdsLogin>
      <san-microfront ref={sanMicrofrontRef}></san-microfront>
    </div>
  );
}
```
