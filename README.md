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

You can generate these using:
```
mix phx.gen.secret
```

## Run
```
mix phx.server
```

## Lint
```
mix credo
```
