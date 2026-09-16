package org.uteq.backend.deportivo.injury.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;

/** Contenedor de los DTO del dominio de lesiones. */
public final class InjuryDtos {
    private InjuryDtos() {}

    /**
     * Datos para registrar una lesión nueva.
     *
     * @param studentId identificador del estudiante lesionado
     * @param coachId identificador del entrenador que reporta, si aplica
     * @param description descripción de la lesión
     * @param injuryDate fecha en que ocurrió la lesión
     * @param estimatedReturnDate fecha estimada de retorno, si se conoce
     */
    public record RegisterInjuryRequest(
            @NotNull Long studentId,
            Long coachId,
            @NotBlank @Size(max = 1000) String description,
            LocalDate injuryDate,
            LocalDate estimatedReturnDate
    ) {}

    /**
     * Fecha de alta médica que cierra una lesión activa.
     *
     * @param dischargeDate fecha del alta médica
     */
    public record DischargeRequest(LocalDate dischargeDate) {}

    /**
     * Vista de una lesión para el cliente.
     *
     * @param injuryId identificador de la lesión
     * @param studentId identificador del estudiante lesionado
     * @param student nombre del estudiante lesionado
     * @param description descripción de la lesión
     * @param injuryDate fecha en que ocurrió la lesión
     * @param estimatedReturnDate fecha estimada de retorno, si se conoce
     * @param dischargeDate fecha del alta médica, si ya se dio
     * @param active si la lesión sigue activa
     */
    public record InjuryResponse(
            Long injuryId,
            Long studentId,
            String student,
            String description,
            LocalDate injuryDate,
            LocalDate estimatedReturnDate,
            LocalDate dischargeDate,
            boolean active
    ) {}
}
