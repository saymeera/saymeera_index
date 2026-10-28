import { Component, ElementRef, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from '../service/common.service';

@Component({
  selector: 'app-tips',
  templateUrl: './tips.component.html',
  styleUrls: ['./tips.component.scss']
})
export class TipsComponent {
  addTipsForm!: FormGroup;
  @ViewChild('closeBtn')closeBtn!:ElementRef
  @ViewChild('addNewTips')addNewTips!:ElementRef
  alltipsList:any
  tipsId:any
  isEditMode:boolean= true


  constructor(private fb: FormBuilder, private toastr: ToastrService, private commonServie: CommonService) {
    this.addTipsForm = this.fb.group({
      tipsScript: ['', Validators.required],
      buySell: ['', Validators.required],
      stopLoss: ['', Validators.required],
      expiryUnit: ['intraday', Validators.required],
      target: ['', Validators.required]
    })
  }

  ngOnInit(){
    this.getAllTips()
  }

  openModal(){
    this.isEditMode = false
  }

  saveTips() {
    if (this.addTipsForm.invalid) {
      this.toastr.error('Pls fill All required fields');
      return
    }
    this.commonServie.saveTips(this.addTipsForm.value).subscribe({
      next: (res: any) => {
        this.toastr.success('Question added');
        this.addTipsForm.reset()
        this.getAllTips()
        this.closeBtn.nativeElement.click()
      },
      error: (err) => {
        this.toastr.error(err.error.message || 'Tips failed');
      }
    })
  }

  getAllTips(){
    this.commonServie.getAlltips().subscribe({
      next:(res:any)=>{
        this.alltipsList = res.data
      },
      error:(err:any)=>{
        this.toastr.error(err.error.message || 'Tips failed');
      }
    })
  }

  editTips(tip:any){
    console.log(tip,"sdhfkjsdhg")
    this.tipsId = tip._id
    this.addNewTips.nativeElement.click()
    this.isEditMode = true
    this.addTipsForm.patchValue({
      tipsScript:tip.tipsScript ,
      buySell:tip.buySell ,
      stopLoss: tip.stopLoss,
      expiryUnit:tip.expiryUnit ,
      target: tip.target
    })
  }

  updateTips(){
    this.commonServie.updatetips(this.tipsId,this.addTipsForm.value).subscribe({
      next:(res:any)=>{
        this.toastr.success('Tips Updated SuccessFully')
        this.closeBtn.nativeElement.click()
        this.getAllTips()
      },
      error:(err:any)=>{
        this.toastr.error(err.error.message || 'Tips failed');
      }
    })
  }

}
