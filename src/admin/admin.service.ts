import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';

@Injectable()
export class AdminService {
  constructor(private prismaService: PrismaService) {}

  async getCountries() {
    return this.prismaService.countries.findMany({
      include: {
        countryTranslation: true,
      },
    });
  }

  async getUsers(take: number, skip: number) {
    const [users, count] = await this.prismaService.$transaction([
      this.prismaService.users.findMany({
        include: {
          roles: true,
        },
        take,
        skip,
      }),
      this.prismaService.users.count(),
    ]);

    return {
      users,
      count,
      take,
      skip,
    };
  }
}
