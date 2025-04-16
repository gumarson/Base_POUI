// import { Component } from '@angular/core';

// @Component({
//   selector: 'app-master-page',
//   templateUrl: './master-page.component.html',
//   styleUrl: './master-page.component.css'
// })
// export class MasterPageComponent {

// }


// import { Component } from '@angular/core';

// @Component({
//   selector: 'app-master-page',
//   templateUrl: './master-page.component.html',
//   styleUrls: ['./master-page.component.css']
// })
// export class MasterPageComponent {

//   centroTrabalho: string = '';
//   dataInicio: string = '';
//   dataFim: string = '';

//   logParams(): void {
//     console.log('Centro de Trabalho:', this.centroTrabalho);
//     console.log('Data Início:', this.dataInicio);
//     console.log('Data Fim:', this.dataFim);
  
//     // ✅ Logando o tipo real:
//     console.log('typeof dataInicio:', typeof this.dataInicio);
//     console.log('typeof dataFim:', typeof this.dataFim);
//   }
  
// }

import { Component } from '@angular/core';
import { Sh8Service } from '../services/sh8.service';

@Component({
  selector: 'app-master-page',
  templateUrl: './master-page.component.html',
  styleUrls: ['./master-page.component.css']
})
export class MasterPageComponent {
  centroTrabalho: string = '';
  dataInicio: string = '';
  dataFim: string = '';

  constructor(private sh8Service: Sh8Service) {}

  buscarDados(): void {
    console.log('🟢 Clicou em Buscar');
    this.sh8Service.getDados(this.centroTrabalho, this.dataInicio, this.dataFim)
      .subscribe({
        next: response => {
          console.log('✅ Resposta recebida da API:', response);
        },
        error: error => {
          console.error('❌ Erro ao consultar API:', error);
        }
      });
  }
}
