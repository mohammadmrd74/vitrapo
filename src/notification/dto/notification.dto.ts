import {
  MaxLength,
  IsString,
  IsNumber,
  IsOptional,
  ValidateIf,
} from 'class-validator';

export class CreateNotificationDto {
  @IsString()
  @IsOptional()
  title: string;

  @IsString()
  @MaxLength(300)
  text: string;

  @IsNumber()
  @ValidateIf((object, value) => value !== null)
  userId: number | null;
}
