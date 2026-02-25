# Dicionário Técnico Progress OpenEdge (Inglês -> Português)

Esse guia serve como um tradutor para as opções que você vê no **AppBuilder (Property Sheet)** e no código **ABL**.

## 🎨 AppBuilder (Janela de Propriedades)

| Termo em Inglês | Tradução/Significado | Explicação |
| :--- | :--- | :--- |
| **Label** | Rótulo / Etiqueta | É o nome que aparece na tela para o usuário (ex: "Nome:", "Senha:"). |
| **Fill-in** | Campo de Entrada | Um campo onde o usuário pode digitar texto ou números. |
| **Enable** | Habilitar | Se marcado, o usuário pode clicar ou digitar no campo. |
| **Display** | Mostrar / Exibir | Se marcado, o valor do campo aparece na tela. |
| **Format** | Formatação | Como o dado aparece (ex: `X(20)` para 20 letras, `>>9.99` para números). |
| **Tooltip** | Dica de Ferramenta | O texto que aparece quando você deixa o mouse parado sobre o botão. |
| **No-Undo** | Sem Desfazer | Desativa o sistema de "rollback" para essa variável (aumenta a performance). |
| **Rectangle** | Retângulo / Bloco | Objeto usado para desenhar molduras e agrupar visualmente outros elementos. |
| **Grid** | Grade | Aqueles pontinhos no fundo que ajudam a alinhar os objetos. |
| **Physical Name** | Nome/Caminho Físico | O caminho real do arquivo no seu computador (ex: `data/infocena.db`). |
| **Logical Name** | Nome Lógico | O "apelido" que o código usa para achar o banco (ex: `infocena`). |
| **Database Field** | Campo do Banco | O campo da tela fica "amarrado" diretamente à tabela do banco de dados. |
| **Local Variable** | Variável Local | O campo existe apenas na tela; você precisa salvar no banco via código. |

---

### 🛠️ Ícones Laterais (Ações)

Ao lado das propriedades, você verá quatro ícones mágicos:

1.  🎨 **Cores (Balde):** Muda as cores e fontes do objeto.
2.  📝 **Triggers (Bloco de Notas):** **MUITO IMPORTANTE!** É aqui que você escreve o que o botão faz (ex: abrir outra tela).
3.  🔍 **Dicionário:** Mostra informações do banco de dados para aquele campo.
4.  💬 **Ajuda:** Explicação do Progress sobre o campo.

---

### 📋 Popup Menu (Menus de Contexto)

Esta tela é aberta quando você clica em **Advanced...** -> **Popup Menu**. Ela serve para:

*   **Menu Elements:** Onde você define os nomes das opções que vão aparecer.
*   **Label:** O texto que o usuário vai ler no menu.
*   **Accelerator:** Onde você define **Atalhos de Teclado** (ex: Ctrl+R para Registrar).
*   **Submenus:** Use os botões `<<` e `>>` para criar níveis dentro do menu.
*   **Ações:** Assim como nos botões, cada item de menu pode ter seu próprio código (Trigger).

---
| **Like** | Como / Igual a | O campo copia todas as propriedades (tamanho, tipo) de um campo do banco. |
| **Left-Align** | Alinhamento à Esquerda | Alinha o objeto ou texto pelo lado esquerdo. |
| **Right-Align** | Alinhamento à Direita | Alinha o objeto ou texto pelo lado direito. |
| **View-As** | Visualizar Como | Define o tipo de objeto (Botão, Lista, Texto, etc.). |

---

### 🔘 Button (Propriedades do Botão)

| Termo em Inglês | Tradução/Significado | Explicação |
| :--- | :--- | :--- |
| **Default Button** | Botão Padrão | Se marcado, esse botão é acionado quando o usuário aperta **ENTER**. |
| **Cancel Button** | Botão de Cancelar | Se marcado, esse botão é acionado quando o usuário aperta **ESC**. |
| **Flat** | Plano | Deixa o botão com um visual mais moderno e "achatado". |
| **No-Focus** | Sem Foco | O botão não "para" quando o usuário vai apertando a tecla TAB. |
| **No-Tab-Stop** | Pular no TAB | O cursor pula esse botão na sequência de navegação do teclado. |
| **Auto-Go** | Auto-Execução | Tenta fechar o frame/janela e retornar "OK" automaticamente ao clicar. |
| **Convert-3D-Colors** | Cores 3D | Ajusta as cores para parecer um botão clássico do Windows (3D). |

---

## 💻 Palavras-chave do Código (ABL)

| Palavra em Inglês | Tradução | O que faz no código? |
| :--- | :--- | :--- |
| **DISPLAY** | Mostrar | Mostra o valor de uma variável na tela. |
| **ENABLE** | Habilitar | Permite que o usuário interaja com o campo. |
| **ASSIGN** | Atribuir | Salva um valor em uma variável ou campo do banco ( `=` em Java/Python). |
| **FOR EACH** | Para Cada | Loop que percorre todos os registros de uma tabela. |
| **FIND FIRST** | Encontrar Primeiro | Busca o primeiro registro que atende a uma condição. |
| **WHERE** | Onde / Quando | Coloca uma condição na busca (Igual no SQL). |
| **MESSAGE** | Mensagem | Abre aquela janelinha de alerta com um texto. |
| **RUN** | Rodar / Executar | Chama outro programa ou uma procedure interna. |

---

## 💡 Dica de Ouro
No Progress, você pode traduzir a "Label" (Rótulo) de qualquer coisa para Português, mas o "Name" (Nome da Variável) é melhor manter sem acentos ou espaços, como você faria no Java.

**Exemplo:**
- **Name:** `fiNomeUsuario`
- **Label:** `Nome do Usuário:`
