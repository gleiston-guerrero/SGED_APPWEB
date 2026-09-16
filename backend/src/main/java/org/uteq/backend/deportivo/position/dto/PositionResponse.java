package org.uteq.backend.deportivo.position.dto;

/**
 * Vista de una posición del catálogo para el cliente.
 *
 * @param positionId identificador de la posición
 * @param name nombre de la posición
 * @param abbreviation abreviatura de la posición
 */
public record PositionResponse(Long positionId, String name, String abbreviation) {}
