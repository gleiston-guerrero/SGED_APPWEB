package org.uteq.backend.common.exception;

import org.springframework.http.HttpStatus;

/**
 * Excepción de negocio para un límite de tasa excedido (responde {@code 429}).
 */
public class TooManyRequestsException extends ApiException {

    /**
     * Crea la excepción para una petición que excede el límite permitido, con el detalle que verá el cliente.
     *
     * @param mensaje detalle legible para el cliente sobre el límite excedido
     */
    public TooManyRequestsException(String mensaje) {
        super(HttpStatus.TOO_MANY_REQUESTS, mensaje);
    }
}
