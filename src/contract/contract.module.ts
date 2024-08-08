import { Module } from '@nestjs/common';
import { ContractService } from './contract.service';
import { ContractController } from './contract.controller';
import { MinioClientModule } from '../minio-client/minio-client.module';

@Module({
  imports: [MinioClientModule],
  controllers: [ContractController],
  providers: [ContractService],
})
export class ContractModule {}
