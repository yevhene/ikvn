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

### Assets
```
cd ./assets && yarn
```

### Environment variables

#### All environments
```
export SECRET_KEY_BASE="_YOUR_VALUE_"
export GUARDIAN_SECRET_KEY="_YOUR_VALUE_"
export FACEBOOK_CLIENT_ID="_YOUR_VALUE_"
export FACEBOOK_CLIENT_SECRET="_YOUR_VALUE_"

# Optional
export PORT=4000
export POOL=10
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

## Deploy

### Checks

#### Check status
```
mix edeliver ping production
```

#### Check version
```
mix edeliver version production
```

#### Check migrations
```
mix edeliver show migrations on production
```

### Release

#### Update code
```
mix edeliver update production
```

#### Run migrations
```
mix edeliver migrate production
```

### Control

#### Start
```
mix edeliver start production
```

#### Stop
```
mix edeliver stop production
```

#### Restart
```
mix edeliver restart production
