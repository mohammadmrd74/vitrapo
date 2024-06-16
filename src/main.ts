import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
// import { WinstonModule } from 'nest-winston';
import { ConfigService } from '@nestjs/config';
// import { instance } from './common/logger/winston.logger';
import helmet from 'helmet';
import { ValidationPipe } from '@nestjs/common';
// import * as csurf from 'csurf';
// import { GrpcExceptionFilter } from './common/interceptor/customError';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.setGlobalPrefix('api');
  app.use(helmet());
  app.enableCors();
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
    }),
  );
  const configService: ConfigService = app.get<ConfigService>(ConfigService);
  const port = configService.get('app.port');

  await app.listen(port);
}

bootstrap();
