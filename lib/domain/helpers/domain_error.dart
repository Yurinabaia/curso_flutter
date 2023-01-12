enum DomainError {
  unexpected,
  insufficientPermissions,
  unableToUpdate,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.unexpected:
        return 'Algo errado aconteceu. Tente novamente em breve.';
      case DomainError.insufficientPermissions:
        return 'Sem permissão para acessar esse recurso.';
      case DomainError.unableToUpdate:
        return 'Não foi possível atualizar os dados.';
      case DomainError.invalidCredentials:
        return 'Credenciais inválidas.';
      default:
        return 'Erro inesperado.';
    }
  }
}
