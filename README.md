# ikvn

## Setup

### Deps
```
mix deps.get
```

### DB
```
mix ecto.setup
```

### Environment variables

#### All environments
```
export SECRET_KEY_BASE=_YOUR_VALUE_
export GUARDIAN_SECRET_KEY=_YOUR_VALUE_
export FACEBOOK_CLIENT_ID=_YOUR_VALUE_
export FACEBOOK_CLIENT_SECRET=_YOUR_VALUE_
```

##### To generate secrets you can user:
```
mix phx.gen.secret
```

##### Facebook
To get Facebook credentials for development you should visit: [Facebook for Developer](https://developers.facebook.com/)

##### Hint
*You can put environment variables in `.env` file and run `source .env` in terminal session.*

## Run
```
mix phx.server
```

## Lint
```
mix credo
```
