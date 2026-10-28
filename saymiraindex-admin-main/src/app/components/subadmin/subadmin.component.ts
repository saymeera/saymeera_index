import { Component, ElementRef, ViewChild } from '@angular/core';
import { FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CommonService } from '../service/common.service';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-subadmin',
  templateUrl: './subadmin.component.html',
  styleUrls: ['./subadmin.component.scss']
})
export class SubadminComponent {
  subAdminForm : FormGroup
  @ViewChild('closeBtn')closeBtn!:ElementRef
  @ViewChild('openAdminModel')openAdminModel!:ElementRef
  adminUserList:any
  constructor(private fb:FormBuilder, private commonService:CommonService, private toastr:ToastrService){
    this.subAdminForm = this.fb.group({
      fullName:['',Validators.required],
      email:['',[Validators.required, Validators.email]],
      password:['',Validators.required],
      role:['',Validators.required],
      permissions:this.fb.array([]),
      mobile:['',[Validators.required, Validators.pattern(/^[6-9]\d{9}$/)]],
      isActive: [true]
    })
  }

  ngOnInit(){
    this.getAdminUser()
  }

  permissionArr = [
    {module:'Dashboard',router:'dashboard'},
    {module:'Quiz',router:'quiz'},
    {module:'User Performance',router:'user-performance'},
    {module:'Tips',router:'tips'},
    {module:'SubAdmin',router:'sub-admin'},
  ]

  get permissions():FormArray{
    return this.subAdminForm.get('permissions') as FormArray
  }

  onPermissionChange(event:any){
    console.log(event,"event")
    const selectedOptions = event.target.defaultValue
    console.log(selectedOptions,"selectedOptions")
    this.permissions.push(this.fb.control(selectedOptions))
  }

  createAdmin(){
    if(this.subAdminForm.invalid){
      this.toastr.error('Pls fill all required Field')
    }
    this.commonService.createAdmin(this.subAdminForm.value).subscribe({
      next:()=>{
        this.toastr.success('Created successfully')
        this.subAdminForm.reset()
        this.closeBtn.nativeElement.click()
      },
      error:()=>{
        this.toastr.error('Error in admin Creation!!')
      }
    })
  }

  getAdminUser(){
    this.commonService.getAdminUsers().subscribe({
      next:(res:any)=>{
        this.adminUserList = res.data
      },
      error:()=>{
        this.toastr.error('Error in getting adminUser list!!')
      }
    })
  }

  edit(data:any){
    this.openAdminModel.nativeElement.click()
    this.subAdminForm.patchValue({
      fullName:data.fullName,
      email:data.email,
      password:data.password,
      role:data.role,
      permissions:data.permissions,
      mobile:data.mobile,
      isActive:data.isActive
    })
  }
}
