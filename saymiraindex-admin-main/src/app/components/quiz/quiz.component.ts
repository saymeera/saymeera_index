import { Component } from '@angular/core';
import { FormArray, FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { AuthService } from 'src/app/auth/service/auth.service';
import { CommonService } from '../service/common.service';

@Component({
  selector: 'app-quiz',
  templateUrl: './quiz.component.html',
  styleUrls: ['./quiz.component.scss']
})
export class QuizComponent {
  quizForm: FormGroup
  addQuistionForm: FormGroup
  toggleOptionType: Boolean = false
  quizlist: any
  recentQuizId: any
  quistionList: any
  isQuizModalOpen = false;
  quizName: any
  isEditMode = false;
  isQuestionEditMode = false
  selectedQuizId: string | null = null;
  QuestionId: string | null = null;

  constructor(private fb: FormBuilder, private authService: AuthService, private toastr: ToastrService, private commonServie: CommonService) {
    this.quizForm = this.fb.group({
      quizNo:['', Validators.required],
      // title: ['', Validators.required],
      totalQuestions: ['', [Validators.required, Validators.pattern('^[0-9]+$')]],
      questionsPerUser: ['', [Validators.required, Validators.pattern('^[0-9]+$')]],
      expiryValue: [1, [Validators.required, Validators.min(1)]],
      expiryUnit: ['hours', Validators.required]
    })

    this.addQuistionForm = this.fb.group({
      quizId: ['', Validators.required],
      questionText: ['', Validators.required],
      optionType: ['', Validators.required],
      options: this.fb.array([]),
      correctOption: ['']
    })
  }

  ngOnInit() {
    this.getQuizList()
  }


  openModal() {
    this.isQuizModalOpen = true;
  }
  createQuizBucket() {
    if (this.quizForm.invalid) {
      this.toastr.error('All fields required');
      return
    }
    this.commonServie.createNewQuiz(this.quizForm.value).subscribe({
      next: () => {
        this.toastr.success('Quiz Created successfully')
        this.quizForm.reset()
        this.closeModal();
        this.getQuizList()
      },
      error: (err) => {
        this.toastr.error('Quiz Creation Failed');
      }
    })
  }
  closeModal() {
    this.isQuizModalOpen = false;
    this.isEditMode = false;
  this.selectedQuizId = null;
  this.quizForm.reset();
  }

  getQuizList() {
    this.commonServie.getQuizlist().subscribe({
      next: (res) => {
        this.quizlist = res.quizlist
        this.recentQuizId = this.quizlist[0]._id
        this.getDefaultQuizQuistion(this.recentQuizId)
        this.quizlist.forEach((quiz: any) => {
          if (quiz.status === 'PUBLISHED' && quiz.expiryAt) {
            this.startTimer(quiz);
          }
        });
      },
      error: () => {
        this.toastr.error('Quiz list Failed');
      }
    })
  }

  get options(): FormArray {
    return this.addQuistionForm.get('options') as FormArray;
  }

  createOption(value: string = '') {
    return this.fb.control(value, Validators.required);
  }

  onTypeChange() {
    const type = this.addQuistionForm.get('optionType')?.value;
    this.options.clear();
    if (type === 'mcq') {
      this.toggleOptionType = true;

      this.options.push(this.createOption());
      this.options.push(this.createOption());
      this.options.push(this.createOption());
      this.options.push(this.createOption());
    }

    if (type === 'tf') {
      this.toggleOptionType = false;

      this.options.push(this.createOption('True'));
      this.options.push(this.createOption('False'));
    }
    this.addQuistionForm.patchValue({ correctAnswer: 0 });

  }

  saveQuestion() {
    if (this.addQuistionForm.invalid) {
      this.toastr.error('Pls fill All required fields');
      return
    }
    this.commonServie.saveQuestion(this.addQuistionForm.value).subscribe({
      next: (res: any) => {
        this.getDefaultQuizQuistion(this.addQuistionForm.value.quizId)
        if (res.quizStatus === 'COMPLETED') {
          this.getQuizList()
        this.toastr.info('Quiz completed. No more questions allowed');
      } else {
        this.toastr.success('Question added');
      }
        this.addQuistionForm.reset()
      },
      error: (err) => {
        this.toastr.error(err.error.message || 'Question failed');
      }
    })
  }

  getDefaultQuizQuistion(recentQuizId: any) {
    let obj = {
      quizId: recentQuizId
    }
    this.commonServie.getDefaultQuizQuestion(obj).subscribe({
      next: (res) => {
        this.quistionList = res?.data
        this.quizName = res.data[0]?.quizId?.quizNo
      },
      error: () => {
        this.toastr.error('error in fetching default Quistion list')
      }
    })

  }

  selectQuiz(quizId: any) {
    this.getDefaultQuizQuistion(quizId)
  }

  publishQuiz(quiz: any) {
    this.commonServie.publishQuiz({ quizId: quiz._id }).subscribe({
      next: (res: any) => {
        quiz.status = 'PUBLISHED';
        quiz.expiryAt = res.quiz.expiryAt;
        this.startTimer(quiz);
      }
    });
  }

  startTimer(quiz: any) {
    this.updateRemainingTime(quiz);

    quiz._timer = setInterval(() => {
      this.updateRemainingTime(quiz);
    }, 1000);
  }

  updateRemainingTime(quiz: any) {
    const now = new Date().getTime();
    const expiry = new Date(quiz.expiryAt).getTime();
    const diff = expiry - now;

    if (diff <= 0) {
      quiz.remainingTime = 'Expired';
      quiz.status = 'EXPIRED';
      clearInterval(quiz._timer);
      return;
    }

    const hours = Math.floor(diff / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((diff % (1000 * 60)) / 1000);

    quiz.remainingTime = `${hours}h ${minutes}m ${seconds}s`;
  }

  editQuiz(quiz:any) {
    this.isEditMode = true;
    this.selectedQuizId = quiz._id;
    this.openModal()
    this.quizForm.patchValue({
    quizNo: quiz.quizNo,
    totalQuestions: quiz.totalQuestions,
    questionsPerUser: quiz.questionsPerUser,
    expiryValue: quiz.expiryValue,
    expiryUnit: quiz.expiryUnit
  });
  }

  updateQuiz(){
  this.commonServie.updateQuizBucket(this.selectedQuizId,this.quizForm.value).subscribe({
    next:(res)=>{
      this.getQuizList()
      this.closeModal();
      this.toastr.success('update quiz')
    },
    error:()=>{
      this.toastr.error('error in updating Quiz')
    }
  })
  }

  deleteQuiz(quizId:any) {
    this.commonServie.deleteQuizBucket(quizId).subscribe({
    next:(res)=>{
      this.getQuizList()
      this.toastr.success('Delete quiz')
    },
    error:()=>{
      this.toastr.error('error in deleting Quiz')
    }
  })
  }

  editQuestion(que: any) {
    this.isQuestionEditMode = true
    this.QuestionId = que._id
    this.selectedQuizId = que.quizId._id
    this.addQuistionForm.patchValue({
      quizId:que.quizId._id ,
      questionText:que.questionText ,
      optionType: que.optionType,
      options:que.options
    })
    this.options.clear();

  // MCQ / TF ke options add karo
  que.options.forEach((opt: any) => {
    this.options.push(
      new FormControl(opt, Validators.required)
    );
  });
  }

  updateQuestion(){
    this.commonServie.updateQuestion(this.QuestionId,this.addQuistionForm.value).subscribe({
      next:(res)=>{
        this.toastr.success('Question Updated Successfully')
        this.getDefaultQuizQuistion(this.selectedQuizId)
        this.addQuistionForm.reset()
      },
      error:()=>{
        this.toastr.error('error in updating Question')
      }
    })
  }

  deleteQuestion(queId: any) {
    this.commonServie.deleteQuestion(queId).subscribe({
      next:(res)=>{
        this.toastr.success('Question deleted Successfully')
        this.getDefaultQuizQuistion(this.selectedQuizId)
      },
      error:()=>{
        this.toastr.error('error in deleting Question')
      }
    })
  }
}
