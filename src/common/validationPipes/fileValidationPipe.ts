import { Injectable, PipeTransform, BadRequestException } from '@nestjs/common';
import { MaxFileSizeValidator, FileTypeValidator } from '@nestjs/common/pipes';

@Injectable()
export class FilesValidationPipe implements PipeTransform {
  transform(files: Record<string, Express.Multer.File[]>) {
    // Get all the keys (fields) in the files object
    if (files instanceof Array) {
      this.validateFiles(files);
    } else {
      Object.keys(files).forEach((field) => {
        const fileArray = files[field];
        this.validateFiles(fileArray);
      });
    }

    return files;
  }

  validateFiles(files) {
    files.forEach((file) => {
      if (!file) {
        throw new BadRequestException('No file uploaded');
      }

      const maxSizeValidator = new MaxFileSizeValidator({
        maxSize: 500000,
        message: 'size should be less than 500kb',
      });

      const fileTypeValidator = new FileTypeValidator({
        fileType: 'image/jpeg|image/png|image/jpg',
      });

      maxSizeValidator.isValid(file);
      fileTypeValidator.isValid(file);
      if (!maxSizeValidator.isValid(file)) {
        throw new BadRequestException('size should be less than 500kb');
      }

      if (!fileTypeValidator.isValid(file)) {
        throw new BadRequestException(
          'Invalid file type. Only JPEG and PNG are allowed.',
        );
      }
    });
  }
}
