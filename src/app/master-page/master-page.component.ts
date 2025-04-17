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
  dados: any[] = [];

  constructor(private sh8Service: Sh8Service) {}

  buscarDados(): void {
    this.sh8Service.getDados(this.centroTrabalho, this.dataInicio, this.dataFim)
      .subscribe({
        next: response => {
          this.dados = response.items;
        },
        error: error => {
          console.error('❌ Erro ao consultar API:', error);
        }
      });
  }

  formatarData(data: string): string {
    if (data?.length === 8) {
      return `${data.substring(6, 8)}/${data.substring(4, 6)}/${data.substring(0, 4)}`;
    }
    return data;
  }

  getColorByStatus(status: string): string {
    switch (status?.toLowerCase()) {
      case 'verde': return '#90EE90';     // lightgreen
      case 'amarelo': return '#FFFF99';   // lightyellow
      case 'laranja': return '#FFA500';   // orange
      case 'vermelho': return '#FF0000';  // red
      default: return 'white';            // fallback
    }
  }
}
