import {
  Body,
  Controller,
  FileTypeValidator,
  Get,
  MaxFileSizeValidator,
  ParseFilePipe,
  Post,
  UploadedFile,
  UseGuards,
  Request,
  UseInterceptors,
} from '@nestjs/common';
import { UserService } from './user.service';
import { ApproveUserDto, CreateUserDto, LoginUserDto } from './dto/user.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { AuthGuard } from 'src/auth/auth.guard';

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
    return this.userService.registerUser(createUser, file, 'users');
  }

  @Post('/login')
  login(@Body() loginUser: LoginUserDto) {
    return this.userService.loginUser(loginUser);
  }

  @Post('/approve')
  approve(@Body() approveUser: ApproveUserDto) {
    return this.userService.approveUser(approveUser);
  }

  @UseGuards(AuthGuard)
  @Get('profile')
  getProfile(@Request() req) {
    return req.user;
  }

  @UseGuards(AuthGuard)
  @Get('list')
  getUsersList(@Request() req) {
    return req.user;
  }
}
