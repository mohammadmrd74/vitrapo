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
import {
  ApproveUserDto,
  CreateUserDto,
  LoginUserDto,
  ChangePasswordUserDto,
  checkHashPasswordUserDto,
  changepasswordRequestDto,
} from './dto/user.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @UseGuards(AuthenticationGuard, AuthorizationGuard)
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
        fileIsRequired: false,
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

  @Post('/forgetpassword/hash')
  checkChangePassword(@Body() body: checkHashPasswordUserDto) {
    return this.userService.checkChangePassword(body);
  }

  @Post('/forgetpassword/request')
  changePasswordRequest(@Body() body: changepasswordRequestDto) {
    return this.userService.changePasswordRequest(body);
  }

  @UseGuards(AuthenticationGuard)
  @Post('/changepassword')
  changepassword(
    @Body() body: ChangePasswordUserDto,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.userService.changepassword(body, req.user);
  }

  @UseGuards(AuthenticationGuard)
  @Get('profile')
  getProfile(@Request() req: Request & { user: object }) {
    return req.user;
  }

  // @UseGuards(AuthenticationGuard, AuthorizationGuard)
  // @Get('list')
  // getUsersList() {
  //   return this.userService.getUserList();
  // }

  @UseGuards(AuthenticationGuard)
  @Get('permissions')
  getUserPersmissions(@Request() req: Request & { user: vtUser }) {
    return this.userService.getUserPersmissions(req.user);
  }
}
