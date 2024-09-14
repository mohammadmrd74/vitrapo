import { IsString } from 'class-validator';

export class CreateTicketCategoryDto {
  @IsString()
  title: string;
}
