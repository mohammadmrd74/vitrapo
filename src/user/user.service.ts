import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { MinioClientService } from 'src/minio-client/minio-client.service';
import { ApproveUserDto, CreateUserDto, LoginUserDto } from './dto/user.dto';
import { PrismaService } from 'src/database/prisma.service';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { users } from '@prisma/client';

type selectedUser = {
  id: number;
  password: string;
  smsTimeLeft: Date;
};

@Injectable()
export class UserService {
  constructor(
    private minioClientService: MinioClientService,
    private prismaService: PrismaService,
    private jwtService: JwtService,
  ) {}

  async registerUser(
    createUser: CreateUserDto,
    file: Express.Multer.File,
    bucket: string,
  ) {
    const imageUrl = await this.uploadSingle(file, bucket);
    const hash = await bcrypt.hash(createUser.password, 10);
    try {
      const user = await this.prismaService.users.create({
        data: {
          ...createUser,
          email: createUser.email || null,
          password: hash,
          profilePicture: imageUrl,
        },
      });

      return {
        id: user.id,
        username: user.username,
        profilePicture: user.profilePicture,
      };
    } catch (error) {
      if (error.code === 'P2002') {
        throw new HttpException(
          'Username already exists',
          HttpStatus.BAD_REQUEST,
        );
      }
    }
  }

  async uploadSingle(image: Express.Multer.File, bucket: string) {
    const uploaded_image = await this.minioClientService.upload(image, bucket);

    return uploaded_image.url;
  }

  async loginUser(loginUser: LoginUserDto) {
    const foundUser = await this.prismaService.users.findFirst({
      select: {
        id: true,
        password: true,
        smsTimeLeft: true,
      },
      where: {
        username: loginUser.username,
      },
    });

    //check user exists
    if (!foundUser)
      throw new HttpException('Username not found', HttpStatus.NOT_FOUND);

    //check password correct
    const isMatch = await bcrypt.compare(
      loginUser.password,
      foundUser.password,
    );

    if (!isMatch)
      throw new HttpException('Incorrect password', HttpStatus.FORBIDDEN);

    //if nothing found or time passed 2 minutes
    if (
      !foundUser.smsTimeLeft ||
      new Date().getTime() - new Date(foundUser.smsTimeLeft).getTime() > 120000
    ) {
      const updateUser = await this.updateUserWithSMScode(foundUser);

      return {
        timeLeft:
          120 -
          Math.ceil(
            (new Date().getTime() -
              new Date(updateUser.smsTimeLeft).getTime()) /
              1000,
          ),
      };
    }

    return {
      timeLeft:
        120 -
        Math.ceil(
          (new Date().getTime() - new Date(foundUser.smsTimeLeft).getTime()) /
            1000,
        ),
    };
  }

  async updateUserWithSMScode(foundUser: selectedUser) {
    const code = Math.floor(Math.random() * 9000) + 1000;
    const date = new Date();
    const updateUser = await this.prismaService.users.update({
      where: {
        id: foundUser.id,
      },
      data: {
        // smscode: code.toString(),
        smscode: '1111',
        smsTimeLeft: date,
      },
    });

    return updateUser;
  }

  async approveUser(approveUser: ApproveUserDto) {
    const foundUser = await this.prismaService.users.findFirst({
      select: {
        id: true,
        smsTimeLeft: true,
        mobile: true,
        email: true,
        roleId: true,
        username: true,
      },
      where: {
        username: approveUser.username,
        smscode: '1111',
        // smscode: approveUser.code,
      },
    });

    //check user exists

    if (!foundUser)
      throw new HttpException('Invalid code', HttpStatus.FORBIDDEN);

    if (
      new Date().getTime() - new Date(foundUser.smsTimeLeft).getTime() >
      120000
    )
      throw new HttpException('Code expired', HttpStatus.FORBIDDEN);

    const payload = {
      sub: foundUser.id,
      username: foundUser.username,
      mobile: foundUser.mobile,
      email: foundUser.email,
      roleId: foundUser.roleId,
    };

    return {
      access_token: await this.jwtService.signAsync(payload, {
        expiresIn: '1d',
      }),
    };
  }

  exclude<T, K extends keyof users>(users: T[], keys: K[]) {
    const result = users.map((user) =>
      Object.fromEntries(
        Object.entries(user).filter(([key]) => !keys.includes(key as K)),
      ),
    );

    return result;
  }

  async getUserList() {
    const users = await this.prismaService.users.findMany();
    const userWithoutPassword = this.exclude(users, ['password']);

    return userWithoutPassword;
  }
}
