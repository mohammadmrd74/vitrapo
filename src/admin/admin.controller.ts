import {
  Body,
  Controller,
  Get,
  Post,
  UseGuards,
  Request,
  ParseIntPipe,
  Query,
  DefaultValuePipe,
  Delete,
} from '@nestjs/common';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';
import { AdminService } from './admin.service';

@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('/countries')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  getCountries() {
    return this.adminService.getCountries();
  }

  @Get('/roles')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  getRoles() {
    return this.adminService.getRoles();
  }

  @Get('/datagroup')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  getAllDG() {
    return this.adminService.getAllDG();
  }

  @Delete('/datagroup')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  deletDG(@Query('id', ParseIntPipe) id: number) {
    return this.adminService.deleteDG(id);
  }

  @Get('/users')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  getUsers(
    @Query('take', new DefaultValuePipe(20), ParseIntPipe) take: number,
    @Query('skip', new DefaultValuePipe(0), ParseIntPipe) skip: number,
    @Query('roleId', new DefaultValuePipe(-1), ParseIntPipe) roleId: number,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.adminService.getUsers(take, skip, roleId, req.user);
  }
}
