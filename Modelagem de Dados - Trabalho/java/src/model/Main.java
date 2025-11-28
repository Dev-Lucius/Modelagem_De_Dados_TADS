package model; 
// Define o pacote onde esta classe está localizada.
// Pacotes ajudam a organizar o código em módulos, tornando o projeto mais legível e modular.

public class Main {
    public static void main(String[] args) {
        // O método main é o ponto de entrada do programa Java.
        // É a primeira função que será executada quando rodamos o programa.

        // --- Testando a Conexão com o Banco de Dados ---
        /*
        try (Connection conn = ConnectionFactory.getConnection()) {
            System.out.println("Conexão bem-sucedida!");
        } catch (Exception e) {
            System.out.println("Erro: " + e.getMessage());
        }
        */

        // Esse bloco foi comentado, mas serve para testar se a conexão com o banco de dados
        // está funcionando corretamente.

        // --- Instanciando os Objetos DAO ---
        // Aqui criamos objetos das classes DAO (Data Access Object).
        // Cada DAO representa um módulo responsável por lidar com uma tabela específica no banco de dados.
        // Isso faz parte do padrão de projeto DAO, que separa a lógica de acesso ao banco da lógica principal do sistema.
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        EventoDAO eventoDAO = new EventoDAO();
        ParticipanteDAO participanteDAO = new ParticipanteDAO();
        InscricaoDAO inscricaoDAO = new InscricaoDAO();

        // --- Cadastrando um Usuário ---
        // Na instância usuarioDAO achama chama o método cadastrarUsuario
        usuarioDAO.cadastrarUsuario("Lucas Oliveira", "lucas@gmail.com", "12345");
        // Chama o método 'cadastrarUsuario' para inserir um novo registro na tabela de usuários.
        // Esse método provavelmente executa um comando SQL do tipo INSERT.

        // --- Buscando um Usuário pelo E-mail ---
        usuarioDAO.buscarUsuarioPorEmail("lucas@gmail.com");
        // Executa uma consulta SQL (SELECT) para localizar um usuário específico com base no e-mail informado.

        // --- Autenticando o Usuário ---
        boolean autenticado = usuarioDAO.autenticarUsuario("lucas@gmail.com", "12345");
        // Chama o método 'autenticarUsuario', que verifica se o e-mail e a senha conferem com o que está no banco.
        // Se o usuário existir e a senha estiver correta, o método retorna 'true'.

        // --- Verificação da Autenticação ---
        if (autenticado) {
            // Se o usuário for autenticado com sucesso, executa o código dentro do bloco.

            // --- Cadastrando um Evento ---
            eventoDAO.cadastrarEvento(
                "Workshop de Tecnologia",                  
                "Evento sobre inovações e tendências em TI", 
                "2025-11-30",                               
                "Auditório Central IFRS",             
                1                                            
            );
            // Esse método envia um comando SQL do tipo INSERT INTO evento (...)
            // para salvar as informações do evento no banco.
            // Note que o último parâmetro (1) é o ID do usuário responsável pelo evento.

            // --- Cadastrando um Participante ---
            participanteDAO.cadastrarParticipante(
                "Rafaela Costa",                 
                "rafaela.costa2@email.com",      
                "(11) 91234-5678"                
            );
            // Aqui, outro INSERT é executado — dessa vez, na tabela de participantes.

            // --- Cadastrando uma Inscrição ---
            inscricaoDAO.cadastrarInscricao(
                1,
                1  
            );
            // Esse método cria o vínculo entre o participante e o evento,
            // Tudo Graças a uma tabela intermediária (ex: inscricao).
        }
    }
}
