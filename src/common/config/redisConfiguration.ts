export default () => ({
  redis: {
    url: process.env.REDIS_URL,
    errorUrl: process.env.REDIS_URL_ERROR,
  },
});
