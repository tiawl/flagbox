#!/bin/bash

function flagbox () {

# Options {{{1

  if [ "x${1}" == "x" ]; then
    echo "help" >&2
    return 1
  fi

  local SOURCE=false
  local CHAIN=""
  local FILE=""

  declare -r FILE_AUTHORIZED='a-zA-Z0-9/_.~\-'
  declare -r PROHIBITED_SYMB='.!#%'

  if [ ${#} -eq 1 ] && [ "${1}" == "--source" ]; then
    SOURCE=true
  elif [ ${#} -eq 2 ] && [ "${1}" == "--chain" ] \
    && [ ${#2} -le ${FLAGBOX_SIZE} ] \
    && [ "x$(printf "${2}" | tr -d '[01]')" == "x" ]; then
      CHAIN="${2}"
  elif [ ${#} -eq 3 ] && [ "${1}" == "--chain" ] && [ "${2}" == "11" ] \
    && [ "x$(print "${3}" | tr -d "[${FILE_AUTHORIZED}]")" == "x" ]; then
      CHAIN="11"
      FILE="${3}"
  else
    echo "help" >&2
    return 1
  fi

# }}}

  declare -r RED=$(tput setaf 1)
  declare -r GREEN=$(tput setaf 2)
  declare -r YELLOW=$(tput setaf 3)
  declare -r REVERSE=$(tput setaf 0)$(tput setab 7)$(tput bold)
  declare -r RESET=$(tput sgr0)

  if ${SOURCE}; then
# --source {{{1
#   Default user variables {{{2

    declare -r DEFAULT_SIZE=3
    declare -r DEFAULT_SYMB1=","
    declare -r DEFAULT_SYMB2="?"
    declare -r DEFAULT_ALIASES=true
    declare -r DEFAULT_DECIMAL_NAVMODE=false
    declare -r DEFAULT_BACKUPCONFIRM=true
    declare -r DEFAULT_VINSERT=false
    declare -r DEFAULT_VNAV=true
    declare -r DEFAULT_VRESET=false
    declare -r DEFAULT_VRESTORE=true
    declare -r DEFAULT_FOLDLISTING=false
    declare -r DEFAULT_STACKBOX=false
    declare -r DEFAULT_AUTOWRITE=false
    declare -r DEFAULT_AUTOWRITEFILE="${HOME}/.flagbox_autowrite"
    declare -r DEFAULT_AUTORESTORE=false
    declare -r DEFAULT_AUTORESTOREFILE="${HOME}/.flagbox_autowrite"

    if [ ! -v FLAGBOX_SIZE ] || [ "x$(printf "${FLAGBOX_SIZE}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_SIZE=${DEFAULT_SIZE}
    fi

    if [ ! -v FLAGBOX_SYMB1 ] || [ "x$(printf "${FLAGBOX_SYMB1}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_SYMB1="${DEFAULT_SYMB1}"
    fi

    if [ ! -v FLAGBOX_SYMB2 ] || [ "x$(printf "${FLAGBOX_SYMB2}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_SYMB2="${DEFAULT_SYMB2}"
    fi

    if [ ! -v FLAGBOX_ALIASES ] || [ "x$(printf "${FLAGBOX_ALIASES}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_ALIASES=${DEFAULT_ALIASES}
    fi

    if [ ! -v FLAGBOX_DECIMAL_NAVMODE ] \
      || [ "x$(printf "${FLAGBOX_DECIMAL_NAVMODE}" \
        | tr -d '[[:space:]]')" == "x" ]; then
          FLAGBOX_DECIMAL_NAVMODE=${DEFAULT_DECIMAL_NAVMODE}
    fi

    if [ ! -v FLAGBOX_BACKUPCONFIRM ] \
      || [ "x$(printf "${FLAGBOX_BACKUPCONFIRM}" \
        | tr -d '[[:space:]]')" == "x" ]; then
          FLAGBOX_BACKUPCONFIRM=${DEFAULT_BACKUPCONFIRM}
    fi

    if [ ! -v FLAGBOX_VINSERT ] || [ "x$(printf "${FLAGBOX_VINSERT}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_VINSERT=${DEFAULT_VINSERT}
    fi

    if [ ! -v FLAGBOX_VNAV ] || [ "x$(printf "${FLAGBOX_VNAV}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_VNAV=${DEFAULT_VNAV}
    fi

    if [ ! -v FLAGBOX_VRESET ] || [ "x$(printf "${FLAGBOX_VRESET}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_VRESET=${DEFAULT_VRESET}
    fi

    if [ ! -v FLAGBOX_VRESTORE ] || [ "x$(printf "${FLAGBOX_VRESTORE}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_VRESTORE=${DEFAULT_VRESTORE}
    fi

    if [ ! -v FLAGBOX_FOLDLISTING ] || [ "x$(printf "${FLAGBOX_FOLDLISTING}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_FOLDLISTING=${DEFAULT_FOLDLISTING}
    fi

    if [ ! -v FLAGBOX_STACKBOX ] || [ "x$(printf "${FLAGBOX_STACKBOX}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_STACKBOX=${DEFAULT_STACKBOX}
    fi

    if [ ! -v FLAGBOX_AUTOWRITE ] || [ "x$(printf "${FLAGBOX_AUTOWRITE}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_AUTOWRITE=${DEFAULT_AUTOWRITE}
    fi

    if [ ! -v FLAGBOX_AUTOWRITEFILE ] \
      || [ "x$(printf "${FLAGBOX_AUTOWRITEFILE}" \
        | tr -d '[[:space:]]')" == "x" ]; then
          FLAGBOX_AUTOWRITEFILE=${DEFAULT_AUTOWRITEFILE}
    fi

    if [ ! -v FLAGBOX_AUTORESTORE ] || [ "x$(printf "${FLAGBOX_AUTORESTORE}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        FLAGBOX_AUTORESTORE=${DEFAULT_AUTORESTORE}
    fi

    if [ ! -v FLAGBOX_AUTORESTOREFILE ] \
      || [ "x$(printf "${FLAGBOX_AUTORESTOREFILE}" \
        | tr -d '[[:space:]]')" == "x" ]; then
          FLAGBOX_AUTORESTOREFILE=${DEFAULT_AUTORESTOREFILE}
    fi

#   }}}

    local NAME=""

#   Check user variables {{{2

    if [ "x$(echo "${FLAGBOX_SIZE}" | tr -d '[0-9]')" != "x" ]; then
      echo "${RED}FLAGBOX_SIZE has to be a positive integer${RESET}" >&2
      return 1
    fi

    if [ ${FLAGBOX_SIZE} -lt 3 ]; then
      echo "${RED}FLAGBOX_SIZE has to be greater or equal to 3${RESET}" >&2
      return 1
    fi

    if [ ${#FLAGBOX_SYMB1} -ne 1 ]; then
      echo "${RED}FLAGBOX_SYMB1 must be a single character${RESET}" >&2
      return 1
    fi

    if [ "x$(printf "${FLAGBOX_SYMB1}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        echo "${RED}FLAGBOX_SYMB1 must be different than a space character" >&2
        return 1
    fi

    if [ "x$(printf "${FLAGBOX_SYMB1}" \
      | tr -d "[${PROHIBITED_SYMB}]")" == "x" ]; then
        echo "${YELLOW}Your are highly discouraged to use one of those characters for FLAGBOX_SYMB1 or FLAGBOX_SYMB2:${RESET} ${PROHIBITED_SYMB}"
    fi

    if [ ${#FLAGBOX_SYMB2} -ne 1 ]; then
      echo "${RED}FLAGBOX_SYMB2 must be a single character${RESET}" >&2
      return 1
    fi

    if [ "x$(printf "${FLAGBOX_SYMB2}" \
      | tr -d '[[:space:]]')" == "x" ]; then
        echo "${RED}FLAGBOX_SYMB2 must be different than a space character" >&2
        return 1
    fi

    if [ "x$(printf "${FLAGBOX_SYMB2}" \
      | tr -d "[${PROHIBITED_SYMB}]")" == "x" ]; then
        echo "${YELLOW}Your are highly discouraged to use one of those characters for FLAGBOX_SYMB1 or FLAGBOX_SYMB2:${RESET} ${PROHIBITED_SYMB}"
    fi

    if [ "${FLAGBOX_SYMB1}" == "${FLAGBOX_SYMB2}" ]; then
      echo "${RED}FLAGBOX_SYMB2 and FLAGBOX_SYMB1 have to be different${RESET}" >&2
      return 1
    fi

    declare -a BIN=( $(I=0; \
      while true; do \
        J="$(perl -e 'printf("%b\n",'${I}')')"; \
        if [ ${#J} -gt ${FLAGBOX_SIZE} ]; then \
          break; \
        fi; \
        echo "$(printf %$(( ${FLAGBOX_SIZE} - ${#J} ))s | tr ' ' '0')$J"; \
        (( I+=1 )); \
      done) )

    local DUP=$(echo -e "$(compgen -c \
      | sort -u)\n$(printf "0 1 00 01 10 11 ${BIN[@]}" \
      | tr '0' "${FLAGBOX_SYMB1}" | tr '1' "${FLAGBOX_SYMB2}" \
      | tr ' ' '\n')" | sort | uniq -d)

    if [ ${#DUP} -gt 0 ]; then
      echo -e "${YELLOW}Your are highly discouraged to use those characters for FLAGBOX_SYMB1 and FLAGBOX_SYMB2. Generating aliases with those characters will hide these commands:${RESET}\n${DUP}"
    fi

    if [ "${FLAGBOX_STACKBOX}" != "false" ] \
      && [ "${FLAGBOX_STACKBOX}" != "true" ]; then
        echo "${RED}FLAGBOX_STACKBOX should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "${FLAGBOX_ALIASES}" != "false" ] \
      && [ "${FLAGBOX_ALIASES}" != "true" ]; then
        echo "${RED}FLAGBOX_ALIASES should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "${FLAGBOX_DECIMAL_NAVMODE}" != "false" ] \
      && [ "${FLAGBOX_DECIMAL_NAVMODE}" != "true" ]; then
        echo "${RED}FLAGBOX_DECIMAL_NAVMODE should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "${FLAGBOX_BACKUPCONFIRM}" != "false" ] \
      && [ "${FLAGBOX_BACKUPCONFIRM}" != "true" ]; then
        echo "${RED}FLAGBOX_BACKUPCONFIRM should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "${FLAGBOX_VINSERT}" != "false" ] \
      && [ "${FLAGBOX_VINSERT}" != "true" ]; then
        echo "${RED}FLAGBOX_VINSERT should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "${FLAGBOX_VNAV}" != "false" ] \
      && [ "${FLAGBOX_VNAV}" != "true" ]; then
        echo "${RED}FLAGBOX_VNAV should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "${FLAGBOX_VRESET}" != "false" ] \
      && [ "${FLAGBOX_VRESET}" != "true" ]; then
        echo "${RED}FLAGBOX_VRESET should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "${FLAGBOX_VRESTORE}" != "false" ] \
      && [ "${FLAGBOX_VRESTORE}" != "true" ]; then
        echo "${RED}FLAGBOX_VRESTORE should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "${FLAGBOX_FOLDLISTING}" != "false" ] \
      && [ "${FLAGBOX_FOLDLISTING}" != "true" ]; then
        echo "${RED}FLAGBOX_FOLDLISTING should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "${FLAGBOX_AUTOWRITE}" != "false" ] \
      && [ "${FLAGBOX_AUTOWRITE}" != "true" ]; then
        echo "${RED}FLAGBOX_AUTOWRITE should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "x$(printf "${FLAGBOX_AUTOWRITEFILE}" \
      | tr -d "[${FILE_AUTHORIZED}]")" != "x" ]; then
        echo "${RED}FLAGBOX_AUTOWRITEFILE should only contains authorized filename characters:${RESET} $(echo "${FILE_AUTHORIZED}" | tr -d '\\')" >&2
        return 1
    fi

    if [ "${FLAGBOX_AUTORESTORE}" != "false" ] \
      && [ "${FLAGBOX_AUTORESTORE}" != "true" ]; then
        echo "${RED}FLAGBOX_AUTORESTORE should be ${RESET} true ${RED}or${RESET} false" >&2
        return 1
    fi

    if [ "x$(printf "${FLAGBOX_AUTORESTOREFILE}" \
      | tr -d "[${FILE_AUTHORIZED}]")" != "x" ]; then
        echo "${RED}FLAGBOX_AUTORESTOREFILE should only contains authorized filename characters:${RESET} $(echo "${FILE_AUTHORIZED}" | tr -d '\\')" >&2
        return 1
    fi

#   }}}

    if [ ! -v FLAGBOX ]; then
      declare -g -A FLAGBOX
      FLAGBOX[BOX]=1
      FLAGBOX[MAX]=1
      FLAGBOX[MODE]="EDIT"
      FLAGBOX[ALIAS]=""
      for I in $(seq 1 ${FLAGBOX_SIZE}); do
        FLAGBOX[1,${I}]=''
      done
    fi

#   Generate aliases {{{2

    if ${FLAGBOX_ALIASES}; then
      for I in $(seq 1 ${FLAGBOX_SIZE}); do
        NAME="$(printf %${I}s | tr ' ' "${FLAGBOX_SYMB1}")"
        alias "${NAME}"="flagbox --chain $(printf %${I}s | tr ' ' '0')"
      done

      for I in ${BIN[@]}; do
        if [ ${I} -gt 0 ]; then
          NAME="$(printf "${I}" | tr '0' "${FLAGBOX_SYMB1}" \
            | tr '1' "${FLAGBOX_SYMB2}")"
          alias "${NAME}"="flagbox --chain ${I}"
          FLAGBOX[ALIAS]="${FLAGBOX[ALIAS]} ${NAME}"
        fi
      done

      alias "${FLAGBOX_SYMB2}"="flagbox --chain 1"
      alias "${FLAGBOX_SYMB2}${FLAGBOX_SYMB2}"="flagbox --chain 11"

      alias "${FLAGBOX_SYMB1}${FLAGBOX_SYMB2}"="flagbox --chain 01"
      alias "${FLAGBOX_SYMB2}${FLAGBOX_SYMB1}"="flagbox --chain 10"
    fi

#   }}}

    unset BIN NAME DUP QUOTED

# }}}
  else
# --chain {{{1
#   Trigger-flag chains {{{2

    if [ ${CHAIN} -eq 0 ]; then
      local NAME=""
      local LENGTH=0

#     EDITION mode {{{3

      if [ "${FLAGBOX[MODE]}" == "EDIT" ]; then
        if [ "x${FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]}" == "x" ]; then
          FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]=$(realpath .)
          ${FLAGBOX_VINSERT} && flagbox --chain 1
        else
          if [ "$(realpath .)" \
            == "${FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]}" ]; then

#       Enter NAVIGATION mode {{{4

              FLAGBOX[MODE]="NAV"

              if ${FLAGBOX_ALIASES}; then
                for I in ${FLAGBOX[ALIAS]}; do
                  unalias "${I}"
                done
                unset FLAGBOX[ALIAS]

#         Generate NAVIGATION mode aliases {{{5

                LENGTH=$(echo -e "3\n$(echo \
                  | awk '{ printf("%0.f", log('"${FLAGBOX[MAX]}"')/log(2)) }')" \
                  | sort -n -r | head -n 1)
                declare -a BIN=( $(I=0; \
                  while true; do \
                    J="$(perl -e 'printf("%b\n",'${I}')')"; \
                    if [ ${#J} -gt ${LENGTH} ]; then \
                      break; \
                    fi; \
                    echo "$(printf %$(( ${LENGTH} - ${#J} ))s | tr ' ' '0')$J"; \
                    (( I+=1 )); \
                  done) )
                for I in $(seq 1 ${FLAGBOX[MAX]}); do
                  if ${FLAGBOX_DECIMAL_NAVMODE}; then
                    NAME="${I}"
                  else
                    NAME="$(printf "${BIN[${I}]}" | tr '0' "${FLAGBOX_SYMB1}" \
                      | tr '1' "${FLAGBOX_SYMB2}")"
                  fi
                  alias "${NAME}"="flagbox --chain ${BIN[${I}]}"
                  FLAGBOX[ALIAS]="${FLAGBOX[ALIAS]} ${NAME}"
                done
                unset BIN
              fi

#         }}}
#       }}}

              echo "NAVIGATION${GREEN} mode used${RESET}"

          else
            if [ -d ${FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]} ]; then
              cd ${FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]}
            else
              echo "${RED}Directory pointed by flag ${RESET}${FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]}{RED} is not available${RESET}"
            fi
          fi
        fi

#     }}}
#     NAVIGATION mode {{{3

      elif [ "${FLAGBOX[MODE]}" == "NAV" ]; then
        if [ "x${FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]}" == "x" ]; then
          FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]=$(realpath .)
          ${FLAGBOX_VINSERT} && flagbox --chain 1
        else
          if [ "$(realpath .)" \
            == "${FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]}" ]; then

#       Enter EDITION mode {{{4

              FLAGBOX[MODE]="EDIT"

              if ${FLAGBOX_ALIASES}; then
                for I in ${FLAGBOX[ALIAS]}; do
                  unalias "${I}"
                done
                unset FLAGBOX[ALIAS]

#         Generate EDITION mode aliases {{{5

                declare -a BIN=( $(I=0; \
                  while true; do \
                    J="$(perl -e 'printf("%b\n",'${I}')')"; \
                    if [ ${#J} -gt ${FLAGBOX_SIZE} ]; then \
                      break; \
                    fi; \
                    echo "$(printf %$(( ${FLAGBOX_SIZE} - ${#J} ))s \
                      | tr ' ' '0')$J"; \
                    (( I+=1 )); \
                  done) )
                for I in ${BIN[@]}; do
                  if [ ${I} -gt 0 ]; then
                    NAME="$(printf "${I}" | tr '0' "${FLAGBOX_SYMB1}" \
                      | tr '1' "${FLAGBOX_SYMB2}")"
                    alias "${NAME}"="flagbox --chain ${I}"
                    FLAGBOX[ALIAS]="${FLAGBOX[ALIAS]} ${NAME}"
                  fi
                done
                unset BIN
              fi

#         }}}
#       }}}

              echo "EDITION${GREEN} mode used${RESET}"

          else
            if [ -d ${FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]} ]; then
              cd ${FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]}
            else
              echo "${RED}Directory pointed by flag ${RESET}${FLAGBOX[${FLAGBOX[BOX]},${#CHAIN}]}{RED} is not available${RESET}"
            fi
          fi
        fi
      fi

#     }}}

      unset LENGTH NAME

#   }}}
#   Binary chains {{{2

    elif [ ${#CHAIN} -eq ${FLAGBOX_SIZE} ]; then
      local DECIMAL=1

#     EDITION mode {{{3

      if [ "${FLAGBOX[MODE]}" == "EDIT" ]; then
        for I in $(seq 1 ${#CHAIN}); do
          if [ "${CHAIN:$(( ${I} - 1 )):1}" == "1" ]; then
            FLAGBOX[${FLAGBOX[BOX]},${I}]=''
          fi
        done
        ${FLAGBOX_VRESET} && flagbox --chain 1

#     }}}
#     NAVIGATION mode {{{3

      elif [ "${FLAGBOX[MODE]}" == "NAV" ]; then
        DECIMAL=$(( 2#${CHAIN} ))
        if [ ${DECIMAL} -gt 0 ] && [ ${DECIMAL} -le ${FLAGBOX[MAX]} ]; then
          FLAGBOX[BOX] = ${DECIMAL}
        fi
      fi

      unset DECIMAL

#     }}}
#   }}}
#   List-flags chain {{{2

    elif [ "${CHAIN}" == "1" ]; then
      local TEXT=""
      local BOXTEXT=""
      local BAR=""
      local TEXTLEN=0
      local BARLEN=0
      local HEIGHT=0
      declare -a DIR
      for I in $(seq 1 ${FLAGBOX_SIZE}); do
        [ "$(realpath .)" == "${FLAGBOX[${FLAGBOX[BOX]},${I}]}" ] && DIR+=(${I})
        TEXT="${TEXT}$(printf %${I}s \
          | tr ' ' "${FLAGBOX_SYMB1}") = ${FLAGBOX[${FLAGBOX[BOX]},${I}]}"
        [ ${I} -lt ${FLAGBOX_SIZE} ] && TEXT="${TEXT}\n"
      done
      TEXTLEN=$(echo -e "${TEXT}" | wc -L)
      BOXTEXT="[ Box ${FLAGBOX[BOX]}/${FLAGBOX[MAX]} | ${FLAGBOX[MODE]} ]"
      BARLEN=$(echo -e "0\n$(( ( ${TEXTLEN} - ${#BOXTEXT} + 1) / 2 ))" \
        | sort -n -r | head -n 1)
      BAR="$(printf %${BARLEN}s | tr ' ' '=')"
      ${FLAGBOX_FOLDLISTING} \
        && while IFS= read -r LINE; do \
             (( HEIGHT+=(${#LINE}/${COLUMNS})+1 )); \
           done < <(echo -e "${BAR}${BOXTEXT}${BAR}\n${TEXT}")
      TEXT=$(printf "${TEXT}\n" | { \
        I=1; \
        while IFS= read -r LINE; do \
          if [ $(printf "%s " "${DIR[@]}" | tr ' ' '\n' | grep -x "${I}" \
            | wc -l) -gt 0 ]; then \
              echo "${REVERSE}${LINE}${RESET}"; \
          else \
            echo "${LINE}"; \
          fi; \
          (( I+=1 )); \
        done; \
      })
      echo -e "${BAR}${BOXTEXT}${BAR}\n${TEXT}"
      if ${FLAGBOX_FOLDLISTING}; then
        echo "Press ? to continue"
        while true; do
          read -s -n 1 INPUT <&1
          [ "${INPUT}" == "?" ] && break
        done
        tput cuu $(( ${HEIGHT} + 1 )) && tput ed
      fi
      unset TEXT TEXTLEN BOXTEXT BARLEN BAR HEIGHT DIR

#   }}}
#   Backup chains {{{2

    elif [ "${CHAIN}" == "11" ]; then
      local BACKUP="${HOME}/.flagbox_backup"
      local CONCAT=""
      local TEXT=""
      local I=1
      local J=1
      for I in $(seq 1 ${FLAGBOX_SIZE}); do
        CONCAT="${CONCAT}x${FLAGBOX[${FLAGBOX[BOX]},${I}]}"
      done
      if [ "x${FILE}" != "x" ]; then
        BACKUP="$(realpath ${FILE})"
      fi

#     Restore {{{3

      if [ ${#CONCAT} -eq ${FLAGBOX_SIZE} ]; then
        if [ -f "${BACKUP}" ]; then

#       Box restore {{{4

          if [ $(cat ${BACKUP} | wc -l) -le ${FLAGBOX_SIZE} ]; then
            while IFS= read -r LINE; do
              FLAGBOX[${FLAGBOX[BOX]},${I}]="${LINE}"
              (( I+=1 ))
            done < ${BACKUP}

#       }}}
#       Full restore {{{4

          else
            unset FLAGBOX && declare -g -A FLAGBOX
            FLAGBOX[BOX]=1
            FLAGBOX[MAX]=1
            FLAGBOX[MODE]="EDIT"
            while IFS= read -r LINE; do
              FLAGBOX[${J},${I}]="${LINE}"
              (( I+=1 ))
              if [ ${I} -gt ${FLAGBOX_SIZE} ]; then
                (( J+=1 ))
                I=1
              fi
            done < ${BACKUP}
          fi

#       }}}

          echo "${GREEN}Marks restored with:${RESET} ${BACKUP}"
          ${FLAGBOX_VRESTORE} && flagbox --chain 1
        fi

#     }}}
#     Save {{{3

      else
        if ${FLAGBOX_BACKUPCONFIRM}; then
          [ -f ${BACKUP} ] && rm -iv ${BACKUP}
        else
          [ -f ${BACKUP} ] && rm ${BACKUP}
        fi
        for I in $(seq 1 ${FLAGBOX_SIZE}); do
          TEXT="${TEXT}$(echo "${FLAGBOX[${FLAGBOX[BOX]},${I}]}")\n"
        done
        printf "${TEXT}" > "${BACKUP}" \
          && echo "${GREEN}Box marks saved at:${RESET} ${BACKUP}"
      fi

#     }}}

      unset I J BACKUP CONCAT TEXT

#   }}}
#   Navigation chains {{{2

    elif [ "${CHAIN}" == "01" ]; then
      local CONCAT=""
      for I in $(seq 1 ${FLAGBOX_SIZE}); do
        CONCAT="${CONCAT}x${FLAGBOX[${FLAGBOX[BOX]},${I}]}"
      done
      if [ ${FLAGBOX[BOX]} -lt ${FLAGBOX[MAX]} ]; then
        (( FLAGBOX[BOX]+=1 ))
      elif [ ${#CONCAT} -gt ${FLAGBOX_SIZE} ]; then
        (( FLAGBOX[BOX]+=1 ))
        for I in $(seq 1 ${FLAGBOX_SIZE}); do
          FLAGBOX[${FLAGBOX[BOX]},${I}]=''
        done
      else
        FLAGBOX[BOX]=1
      fi
      FLAGBOX[MAX]=$(echo -e "${FLAGBOX[BOX]}\n${FLAGBOX[MAX]}" \
        | sort -n -r | head -n 1)
      unset CONCAT
      ${FLAGBOX_VNAV} && flagbox --chain 1
    elif [ "${CHAIN}" == "10" ]; then
      if [ ${FLAGBOX[BOX]} -gt 1 ]; then
        (( FLAGBOX[BOX]-=1 ))
      else
        FLAGBOX[BOX]=${FLAGBOX[MAX]}
      fi
      ${FLAGBOX_VNAV} && flagbox --chain 1
    fi

#   }}}
# }}}

  fi
}

[ -f "${HOME}/.flagbox.conf" ] && source "${HOME}/.flagbox.conf"
if [ ! -f "${HOME}/.flagbox.conf" ]; then
  flagbox --source
elif [ -v FLAGBOX_ALIASES ] && ${FLAGBOX_ALIASES}; then
  flagbox --source
fi
