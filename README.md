# TechRise Payment API — DevSecOps Pipeline (Mini Project 3)

A sample Flask payment API demonstrating a complete DevSecOps security pipeline.

## Branches
- `main` — vulnerable baseline (deliberately insecure, for demonstrating pipeline failure)
- `secure` — hardened version (passes all 5 security gates)

## Pipeline
5-stage security pipeline in `.github/workflows/security.yml`:
1. TruffleHog — secret detection
2. Bandit — Python SAST
3. Safety — dependency CVE scanning
4. Trivy — Docker image scanning
5. Checkov — IaC/Dockerfile security scanning

All jobs block the pipeline on HIGH/CRITICAL findings.
