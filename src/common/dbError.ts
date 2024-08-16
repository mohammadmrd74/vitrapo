import { HttpException, HttpStatus } from '@nestjs/common';

export function dbError(error) {
  if (!error.code) return error;
  switch (error.code) {
    case 'P2011':
      throw new HttpException(
        `request failed. please try again later`,
        HttpStatus.NOT_ACCEPTABLE,
      );
    case 'P2002':
      throw new HttpException(
        `${error?.meta?.modelName} already exists`,
        HttpStatus.BAD_REQUEST,
      );
      break;
    case 'P2003':
      throw new HttpException(
        `${error?.meta?.field_name} doesn't exist.`,
        HttpStatus.NOT_FOUND,
      );
      break;
    case 'P2025':
      throw new HttpException(error?.meta?.cause, HttpStatus.NOT_FOUND);
      break;

    default:
      break;
  }
}
