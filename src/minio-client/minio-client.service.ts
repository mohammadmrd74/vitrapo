import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { MinioService, MinioClient } from 'nestjs-minio-client';
import * as crypto from 'crypto';
import { ConfigService } from '@nestjs/config/dist/config.service';

@Injectable()
export class MinioClientService {
  constructor(
    private readonly minio: MinioService,
    private configService: ConfigService,
  ) {}

  public get client(): MinioClient {
    return this.minio.client;
  }

  public async upload(file: Express.Multer.File, baseBucket: string) {
    if (!(file.mimetype.includes('jpeg') || file.mimetype.includes('png'))) {
      throw new HttpException('Error uploading file', HttpStatus.BAD_REQUEST);
    }
    const temp_filename = Date.now().toString();
    const hashedFileName = crypto
      .createHash('md5')
      .update(temp_filename)
      .digest('hex');
    const ext = file.originalname.substring(
      file.originalname.lastIndexOf('.'),
      file.originalname.length,
    );

    const filename = hashedFileName + ext;
    const fileName: string = `${filename}`;
    const fileBuffer = file.buffer;
    try {
      await this.client.putObject(baseBucket, fileName, fileBuffer);
    } catch (error) {
      console.log(error);

      throw new HttpException('Error uploading file', HttpStatus.BAD_REQUEST);
    }

    return {
      url: `${this.configService.get<string>('MINIO_FILE_ENDPOINT')}:${this.configService.get<string>('MINIO_PORT')}/${baseBucket}/${filename}`,
    };
  }

  public async uploadMany(
    files: Array<Express.Multer.File>,
    baseBucket: string,
  ) {
    const urls: Array<string> = [];
    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      const temp_filename = Date.now().toString();
      const hashedFileName = crypto
        .createHash('md5')
        .update(temp_filename)
        .digest('hex');
      const ext = file.originalname.substring(
        file.originalname.lastIndexOf('.'),
        file.originalname.length,
      );
      const filename = hashedFileName + ext;
      const fileName: string = `${filename}`;
      const fileBuffer = file.buffer;
      try {
        await this.client.putObject(baseBucket, fileName, fileBuffer);
      } catch (error) {
        console.log(error);

        throw new HttpException('Error uploading file', HttpStatus.BAD_REQUEST);
      }
      urls.push(
        `${this.configService.get<string>('MINIO_FILE_ENDPOINT')}:${this.configService.get<string>('MINIO_PORT')}/${baseBucket}/${filename}`,
      );
    }

    return urls;
  }

  async delete(objetName: string, baseBucket: string) {
    try {
      await this.client.removeObject(baseBucket, objetName);
    } catch (error) {
      throw new HttpException(
        'Oops Something wrong happened',
        HttpStatus.BAD_REQUEST,
      );
    }

    return 'done';
  }
}
