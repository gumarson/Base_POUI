// import { Component } from '@angular/core';
// import { Sh8Service } from '../services/sh8.service';

// @Component({
//   selector: 'app-master-page',
//   templateUrl: './master-page.component.html',
//   styleUrls: ['./master-page.component.css']
// })
// export class MasterPageComponent {
//   centroTrabalho: string = '';
//   dataInicio: string = '';
//   dataFim: string = '';

//   constructor(private sh8Service: Sh8Service) {}

//   buscarDados(): void {
//     console.log('🟢 Clicou em Buscar');
//     this.sh8Service.getDados(this.centroTrabalho, this.dataInicio, this.dataFim)
//       .subscribe({
//         next: response => {
//           console.log('✅ Resposta recebida da API:', response);
//         },
//         error: error => {
//           console.error('❌ Erro ao consultar API:', error);
//         }
//       });
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
  dados: any[] = []; // ← Armazena os dados da API

  constructor(private sh8Service: Sh8Service) {}

  buscarDados(): void {
    console.log('🟢 Clicou em Buscar');
    this.sh8Service.getDados(this.centroTrabalho, this.dataInicio, this.dataFim)
      .subscribe({
        next: response => {
          console.log('✅ Resposta recebida da API:', response);
          this.dados = response.items; // ← Popula a tabela
        },
        error: error => {
          console.error('❌ Erro ao consultar API:', error);
        }
      });
  }
}
