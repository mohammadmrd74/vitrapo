import { MaxLength, IsString } from 'class-validator';

export class CreateTicketDto {
  @IsString()
  categoryId: string;

  @IsString()
  @MaxLength(100)
  title: string;

  @IsString()
  @MaxLength(500)
  message: string;
}
