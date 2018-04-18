# React CLI with Docker

You can use this to build and use an image with React installed for CLI operations and more.

**Start the React CLI with this:**

```sh
$ docker-compose -f docker-compose-React-CLI.yml run app sh
```

You can create an image installing React & create-sample-app in it, to create a sample:

```sh
$ npx create-react-app sample-app
```