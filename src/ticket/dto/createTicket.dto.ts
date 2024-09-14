import { MaxLength, IsString, IsNotEmpty } from 'class-validator';

export class CreateTicketDto {
  @IsString()
  categoryId: string;

  @IsString()
  @MaxLength(100)
  @IsNotEmpty()
  title: string;

  @IsString()
  @MaxLength(500)
  @IsNotEmpty()
  message: string;
}

export class CreateTicketMessageDto {
  @IsString()
  ticketId: string;

  @IsString()
  @MaxLength(500)
  @IsNotEmpty()
  message: string;
}
