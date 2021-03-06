/*
 * Copyright (C) 2021 - present Instructure, Inc.
 *
 * This file is part of Canvas.
 *
 * Canvas is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, version 3 of the License.
 *
 * Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * this file is generated by scripts/getTranslationGetters. do not edit
 */

export default function getRceTranslations(locale) {
  let p
  switch (locale) {
    case 'ar':
      p = import('./locales/ar')
      break
    case 'ca':
      p = import('./locales/ca')
      break
    case 'cy':
      p = import('./locales/cy')
      break
    case 'da-x-k12':
      p = import('./locales/da-x-k12')
      break
    case 'da':
      p = import('./locales/da')
      break
    case 'de':
      p = import('./locales/de')
      break
    case 'el':
      p = import('./locales/el')
      break
    case 'en-AU-x-unimelb':
      p = import('./locales/en-AU-x-unimelb')
      break
    case 'en-AU':
      p = import('./locales/en-AU')
      break
    case 'en-GB-x-ukhe':
      p = import('./locales/en-GB-x-ukhe')
      break
    case 'en-GB':
      p = import('./locales/en-GB')
      break
    case 'es':
      p = import('./locales/es')
      break
    case 'fa-IR':
      p = import('./locales/fa-IR')
      break
    case 'fr-CA':
      p = import('./locales/fr-CA')
      break
    case 'fr':
      p = import('./locales/fr')
      break
    case 'he':
      p = import('./locales/he')
      break
    case 'ht':
      p = import('./locales/ht')
      break
    case 'hu':
      p = import('./locales/hu')
      break
    case 'hy':
      p = import('./locales/hy')
      break
    case 'is':
      p = import('./locales/is')
      break
    case 'it':
      p = import('./locales/it')
      break
    case 'ja':
      p = import('./locales/ja')
      break
    case 'ko':
      p = import('./locales/ko')
      break
    case 'mi':
      p = import('./locales/mi')
      break
    case 'nb-x-k12':
      p = import('./locales/nb-x-k12')
      break
    case 'nb':
      p = import('./locales/nb')
      break
    case 'nl':
      p = import('./locales/nl')
      break
    case 'nn':
      p = import('./locales/nn')
      break
    case 'pl':
      p = import('./locales/pl')
      break
    case 'pt-BR':
      p = import('./locales/pt-BR')
      break
    case 'pt':
      p = import('./locales/pt')
      break
    case 'ru':
      p = import('./locales/ru')
      break
    case 'sv-x-k12':
      p = import('./locales/sv-x-k12')
      break
    case 'sv':
      p = import('./locales/sv')
      break
    case 'tr':
      p = import('./locales/tr')
      break
    case 'uk':
      p = import('./locales/uk')
      break
    case 'zh-Hans':
      p = import('./locales/zh-Hans')
      break
    case 'zh-Hant':
      p = import('./locales/zh-Hant')
      break
    default:
      p = Promise.resolve(null)
  }
  return p
}
