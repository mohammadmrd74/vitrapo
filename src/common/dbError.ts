import { HttpException, HttpStatus } from '@nestjs/common';

export function dbError(error) {
  if (!error.code) return error;
  switch (error.code) {
    case 'P2002':
      throw new HttpException(
        'contract already exists',
        HttpStatus.BAD_REQUEST,
      );
      break;
    case 'P2003':
      throw new HttpException('object not found', HttpStatus.NOT_FOUND);
      break;

    default:
      break;
  }
}
