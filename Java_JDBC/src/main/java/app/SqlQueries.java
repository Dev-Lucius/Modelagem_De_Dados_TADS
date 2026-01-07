package app;

public final class SqlQueries {

    // =========================
    // CLIENTE
    // =========================

    public static final String INSERT_CLIENTE =
        "INSERT INTO cliente (nome, email) VALUES (?, ?)";

    public static final String SELECT_CLIENTE_POR_ID =
        "SELECT id, nome, email FROM cliente WHERE id = ?";

    public static final String SELECT_TODOS_CLIENTES =
        "SELECT id, nome, email FROM cliente";

    public static final String UPDATE_CLIENTE =
        "UPDATE cliente SET nome = ?, email = ? WHERE id = ?";

    public static final String DELETE_CLIENTE =
        "DELETE FROM cliente WHERE id = ?";


    // =========================
    // UTILIDADES
    // =========================

    private SqlQueries() {
        // Impede instanciação
    }
}
