import {
  MaxLength,
  IsString,
  IsNumber,
  Length,
  IsDateString,
  Max,
} from 'class-validator';

export class CreateContractInstallmentDto {
  @IsNumber()
  contractId: number;

  @IsString()
  @MaxLength(100)
  title: string;

  @IsNumber()
  @Max(30)
  installmentNumber: number;

  @IsNumber()
  price: number;

  @IsString()
  @Length(3, 3)
  priceCurrency: string = 'IRR';

  @IsDateString()
  dueDate: Date;

  @IsNumber()
  deadLine: number = 0;
}

export class CreateContractInstallmentFileDto {
  @IsString()
  installmentId: string;
}

export class CreateInstallmentMessageDto {
  @IsNumber()
  installmentId: number;

  @IsString()
  @MaxLength(200)
  message: string;
}
