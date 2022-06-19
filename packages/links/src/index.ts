import { defineEndpoint } from "@directus/extensions-sdk";

export default defineEndpoint((router, { services, exceptions }) => {
  const { ItemsService } = services;
  const { ServiceUnavailableException } = exceptions;

  router.get("/", async (_req, res, next) => {
    const linksService = new ItemsService("links");
    linksService
      .readByQuery()
      .then((results: any) => res.json(results))
      .catch((error: any) => {
        return next(new ServiceUnavailableException(error.message));
      });
  });
});
