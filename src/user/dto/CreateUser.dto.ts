import { MaxLength, IsString, Matches, IsOptional } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @MaxLength(11)
  mobile: number;

  @IsString()
  @MaxLength(50)
  @IsOptional()
  email: number;

  @IsString()
  @MaxLength(20)
  @Matches(/((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message: 'password too weak',
  })
  password: string;

  @IsString()
  @MaxLength(50)
  name: number;

  @IsString()
  @MaxLength(50)
  family: number;
}
