module Network.DomainAuth.PRD.Domain (
    extractDomain
  ) where

import Network.DNS (Domain)
import Network.DomainAuth.Mail
import Network.DomainAuth.PRD.Lexer
import Text.Appar.ByteString
import qualified Data.ByteString.Char8 as BS

-- | Extract a domain from a value of a header field.
--
-- >>> extractDomain "Alice Brown <alice.brown@example.com>"
-- Just "example.com"
-- >>> extractDomain "\"Alice . Brown\" <alice.brown@example.com> (Nickname here)"
-- Just "example.com"
-- >>> extractDomain "alice.brown@example.com"
-- Just "example.com"
-- >>> extractDomain "Alice Brown <example.com>"
-- Nothing

extractDomain :: RawFieldValue -> Maybe Domain
extractDomain bs = parse structured bs >>= takeDomain
    where
      takeDomain = dropTail . dropWhile (/="@")
      dropTail [] = Nothing
      dropTail xs = (Just . BS.pack . concat . takeWhile (/=">") . tail) xs
