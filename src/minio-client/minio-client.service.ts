import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { ConfigService } from '@nestjs/config/dist/config.service';
import * as crypto from 'crypto';
import * as fs from 'fs/promises';
import * as path from 'path';

@Injectable()
export class MinioClientService {
  constructor(private configService: ConfigService) {}

  private get storageRoot(): string {
    return (
      this.configService.get<string>('FILE_STORAGE_PATH') ||
      path.resolve(process.cwd(), 'uploads')
    );
  }

  private get baseUrl(): string {
    return (
      this.configService.get<string>('FILE_BASE_URL') ||
      'http://localhost:4000/files'
    );
  }

  private hashedName(originalname: string, prefix = ''): string {
    const hash = crypto
      .createHash('md5')
      .update(Date.now().toString() + Math.random())
      .digest('hex');
    const ext = originalname.substring(originalname.lastIndexOf('.'));
    return `${prefix}${hash}${ext}`;
  }

  private async writeFile(
    baseBucket: string,
    filename: string,
    buffer: Buffer,
  ): Promise<void> {
    const dir = path.join(this.storageRoot, baseBucket);
    await fs.mkdir(dir, { recursive: true });
    await fs.writeFile(path.join(dir, filename), buffer);
  }

  public async upload(file: Express.Multer.File, baseBucket: string) {
    if (!(file.mimetype.includes('jpeg') || file.mimetype.includes('png'))) {
      throw new HttpException('Error uploading file', HttpStatus.BAD_REQUEST);
    }
    const filename = this.hashedName(file.originalname);
    try {
      await this.writeFile(baseBucket, filename, file.buffer);
    } catch (error) {
      console.log(error);
      throw new HttpException('Error uploading file', HttpStatus.BAD_REQUEST);
    }
    return { url: `${this.baseUrl}/${baseBucket}/${filename}` };
  }

  public async uploadMany(
    files: Array<Express.Multer.File>,
    baseBucket: string,
  ) {
    const urls: Array<string> = [];
    for (const file of files) {
      const filename = this.hashedName(file.originalname, 'files');
      try {
        await this.writeFile(baseBucket, filename, file.buffer);
      } catch (error) {
        console.log(error);
        throw new HttpException('Error uploading file', HttpStatus.BAD_REQUEST);
      }
      urls.push(`${this.baseUrl}/${baseBucket}/${filename}`);
    }
    return urls;
  }

  async delete(objectName: string, baseBucket: string) {
    try {
      await fs.unlink(path.join(this.storageRoot, baseBucket, objectName));
    } catch (error) {
      throw new HttpException(
        'Oops Something wrong happened',
        HttpStatus.BAD_REQUEST,
      );
    }
    return 'done';
  }
}
