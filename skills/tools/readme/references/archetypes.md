# README archetypes

Choose one primary archetype. Combine sections only when the repository serves genuinely different audiences; name each path explicitly.

## Product, library, SDK, or CLI

**Primary audience:** adopter or evaluator.

Prioritize:

1. value proposition and supported use case;
2. prerequisites and installation;
3. minimal working example;
4. common usage and expected output;
5. compatibility or support boundaries;
6. links to API docs, examples, support, contributing, and license.

Show the public interface before implementation architecture. Separate installation from development setup.

## Application or service

**Primary audience:** operator, deployer, or contributor.

Prioritize:

1. what the application does;
2. local startup path;
3. required services and configuration;
4. verification or health check;
5. deployment and operations links;
6. architecture and contribution links.

Name the supported environment. Distinguish local development from production deployment.

## Internal repository

**Primary audience:** teammate joining or returning to the project.

Prioritize:

1. repository purpose and ownership;
2. access prerequisites;
3. local setup and verification;
4. architecture map and important boundaries;
5. common development tasks;
6. runbooks, release process, and support channels.

Link to the canonical internal systems. Keep secrets and private payloads out of the README.

## Config, dotfiles, or template repository

**Primary audience:** future maintainer or copier.

Prioritize:

1. what is configured or generated;
2. prerequisites and target locations;
3. install, link, copy, or generation steps;
4. customization seams;
5. platform-specific behavior and recovery;
6. notable conventions and gotchas.

Explain what a destructive setup command changes before asking the reader to run it.

## Curated collection or resource list

**Primary audience:** reader searching a defined topic.

Prioritize:

1. scope and inclusion bar;
2. categorized navigation;
3. concise, consistent item annotations;
4. contribution and review rules;
5. maintenance or archival policy;
6. license.

Curate rather than accumulate. Define how entries are evaluated and remove dead or out-of-scope links.

## GitHub profile

**Primary audience:** visitor deciding who this person or organization is and where to go next.

Prioritize:

1. identity and one-line focus;
2. current work or expertise;
3. a small set of flagship projects;
4. one deduplicated contact or navigation cluster;
5. optional activity or social proof.

Keep the body scan-first. Link to project READMEs instead of reproducing their install guides, feature matrices, or contribution instructions. Treat third-party badges and widgets as optional dependencies, not core content.

## Section selection test

For every proposed section, answer:

- Which reader question does it answer?
- Is this README the canonical owner of the answer?
- Does the reader need it before their next action?

Remove, defer, or link out when any answer is unclear.
