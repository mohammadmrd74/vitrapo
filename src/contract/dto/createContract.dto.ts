import { MaxLength, IsString } from 'class-validator';

export class CreateContractDto {
  @IsString()
  applicantId: string;

  @IsString()
  @MaxLength(100)
  title: string;

  @IsString()
  issueDate: Date;

  @IsString()
  executeDate: Date;

  @IsString()
  totalPrice: string;

  @IsString()
  istallmetNumbers: string;

  @IsString()
  @MaxLength(20)
  status: string;
}
