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
