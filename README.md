# BlockScanners

<p align="center">
  <a href="https://oftcer.com"><img src="https://img.shields.io/badge/site-oftcer.com-111111?style=flat-square" alt="oftcer.com" /></a>
  <img src="https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white" alt="PowerShell" />
  <img src="https://img.shields.io/badge/Windows-0078D6?style=flat-square&logo=windows&logoColor=white" alt="Windows" />
</p>

Ferramenta de segurança para **Windows / VPS** que bloqueia no Firewall do Windows os ranges de IP usados por scanners públicos da internet.

**oftcer** · [oftcer.com](https://oftcer.com)

---

## O que faz

O BlockScanners cria regras **Inbound → Block** no Firewall do Windows para impedir que scanners conhecidos alcancem sua máquina e mapeiem portas abertas.

Scanners bloqueados:

| Scanner       | Ranges (CIDR)                          |
|---------------|----------------------------------------|
| Shodan        | `198.20.87.0/24`, `185.163.109.0/24`, `71.6.165.0/24`, `66.240.236.0/24` |
| Censys        | `167.94.138.0/24`, `167.94.145.0/24`   |
| Shadowserver  | `64.62.202.0/24`, `204.42.253.0/24`    |
| BinaryEdge    | `185.244.25.0/24`                      |
| ZoomEye       | `103.120.226.0/24`                     |

### O que NÃO faz

- Não fecha todas as portas da VPS
- Não substitui um firewall completo (security group da cloud, fail2ban, etc.)
- Não bloqueia scanners novos ou IPs fora da lista

Use como **camada extra** de proteção, junto com boas práticas (SSH só por chave, portas mínimas abertas, atualizações, etc.).

---

## Requisitos

- Windows Server ou Windows 10/11
- Executar como **Administrador**
- PowerShell com módulo NetSecurity (`New-NetFirewallRule`)

---

## Como usar

### Opção 1 — Duplo clique (recomendado)

1. Coloque `BlockScanners.bat` e `Block-Scanners.ps1` na mesma pasta
2. Clique com o botão direito em `BlockScanners.bat` → **Executar como administrador**
3. Confirme o UAC se aparecer
4. Veja o resumo no terminal (criadas / já existentes / falhas)

### Opção 2 — PowerShell

Abra o PowerShell **como Administrador** na pasta do projeto:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\Block-Scanners.ps1
```

---

## Arquivos

```
BlockScanners/
├── BlockScanners.bat      # Launcher (eleva privilégios e chama o .ps1)
├── Block-Scanners.ps1     # Aplica as regras no Firewall do Windows
├── LICENSE                # Licença MIT
└── README.md              # Esta documentação
```

---

## Comportamento seguro

- Se a regra **já existir**, o script **não duplica** — apenas marca como existente
- Nomes das regras usam o prefixo `BlockScanners - ...` para fácil identificação
- Perfil: `Any` (Domain, Private e Public)
- Direção: apenas **Inbound** (entrada)

### Ver regras criadas

```powershell
Get-NetFirewallRule -DisplayName "BlockScanners*" | Format-Table DisplayName, Enabled, Direction, Action
```

### Remover todas as regras do BlockScanners

```powershell
Get-NetFirewallRule -DisplayName "BlockScanners*" | Remove-NetFirewallRule
```

---

## Aviso

Bloquear scanners reduz a exposição em bases públicas (Shodan, Censys, etc.), mas **não torna a VPS invulnerável**. Mantenha portas desnecessárias fechadas e o sistema atualizado.

Ranges de IP de scanners podem mudar com o tempo — revise e atualize a lista quando necessário.

---

## Autor

**oftcer** · [oftcer.com](https://oftcer.com)

Projeto: BlockScanners  
Licença: MIT
