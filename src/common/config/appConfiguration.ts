export default () => ({
  app: {
    port: parseInt(process.env.APP_PORT),
    name: process.env.APP_NAME,
    appEnv: process.env.APP_ENV,
  },
});
