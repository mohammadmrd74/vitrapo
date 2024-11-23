import {
  MaxLength,
  IsString,
  Matches,
  IsOptional,
  MinLength,
  IsNumber,
} from 'class-validator';

export class CreateUserDto {
  @IsString()
  @MaxLength(11)
  mobile: string;

  @IsString()
  @MaxLength(50)
  @IsOptional()
  email: string;

  @IsString()
  @MaxLength(50)
  @IsOptional()
  username: string;

  @IsString()
  @IsOptional()
  roleId: string;

  @IsString()
  @MaxLength(20)
  @Matches(/((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message: 'password too weak',
  })
  password: string;

  @IsString()
  @MaxLength(50)
  name: string;

  @IsString()
  @MaxLength(50)
  family: string;
}

export class LoginUserDto {
  @IsString()
  @MaxLength(50)
  @IsOptional()
  username: string;

  @IsString()
  @MaxLength(20)
  @Matches(/((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message: 'password too weak',
  })
  password: string;
}

export class ApproveUserDto {
  @IsString()
  @MaxLength(50)
  @IsOptional()
  username: string;

  @IsString()
  @MaxLength(5)
  @MinLength(5)
  code: string;
}
export class ChangePasswordUserDto {
  @IsString()
  @MaxLength(20)
  @Matches(/((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message: 'password too weak',
  })
  password: string;
}
export class checkHashPasswordUserDto {
  @IsString()
  hash: string;
}
export class changepasswordRequestDto {
  @IsString()
  username: string;
}
