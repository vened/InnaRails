import ReactOnRails from 'react-on-rails';
import HelloWorldApp from './HelloWorldAppClient';
import Header from '../components/Header';

// This is how react_on_rails can see the HelloWorldApp in the browser.
ReactOnRails.register({ HelloWorldApp });
ReactOnRails.register({ Header });
