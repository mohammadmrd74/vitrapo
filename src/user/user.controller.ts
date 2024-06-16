import {
  Body,
  Controller,
  FileTypeValidator,
  MaxFileSizeValidator,
  ParseFilePipe,
  Post,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/CreateUser.dto';
import { FileInterceptor } from '@nestjs/platform-express';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('/register')
  @UseInterceptors(FileInterceptor('profilePicture'))
  register(
    @Body() createUser: CreateUserDto,
    @UploadedFile(
      new ParseFilePipe({
        validators: [
          new MaxFileSizeValidator({
            maxSize: 500000,
            message: 'size should be less than 500kb',
          }),
          new FileTypeValidator({ fileType: 'image/jpeg|image/png' }),
        ],
      }),
    )
    file: Express.Multer.File,
  ) {
    return this.userService.uploadSingle(file, 'users');
  }
}
