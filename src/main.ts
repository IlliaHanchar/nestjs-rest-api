import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { HttpExceptionFilter } from './exception-filters/http-exception-filter';
import AppConfig from './app.config';
import { applyDocs } from './api-docs/apply-docs';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    preflightContinue: false,
    optionsSuccessStatus: 204,
  });

  app.useGlobalPipes(new ValidationPipe());

  app.useGlobalFilters(new HttpExceptionFilter());

  applyDocs(app);

  const port = new AppConfig().build().metaData.port;

  await app.listen(port, () => {
    console.info(`The app is up and running on ${port} port`);
  });
}

bootstrap().then();
