package org.uteq.backend.common.exception;

import org.springframework.http.HttpStatus;

/**
 * Excepción de negocio para un recurso que no existe (responde {@code 404}).
 */
public class ResourceNotFoundException extends ApiException {

    /**
     * Crea la excepción para un recurso que no existe, con el detalle que verá el cliente.
     *
     * @param mensaje detalle legible para el cliente sobre qué recurso no se
     *                encontró
     */
    public ResourceNotFoundException(String mensaje) {
        super(HttpStatus.NOT_FOUND, mensaje);
    }
}
