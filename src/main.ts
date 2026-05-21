import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from './app.module';
import { ConfigService } from '@nestjs/config';
import helmet from 'helmet';
import { ValidationPipe } from '@nestjs/common';
import * as path from 'path';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.setGlobalPrefix('api');
  const storageRoot =
    process.env.FILE_STORAGE_PATH || path.resolve(process.cwd(), 'uploads');
  app.useStaticAssets(storageRoot, { prefix: '/files/' });
  app.use(helmet({ crossOriginResourcePolicy: false }));
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
